import {io} from "../server/server";
import {WsConnection} from "./ws-connection";
import {RoomService} from "../services/room-service";
import {UserBoardService} from "../services/user-board-service";
import {Room, RoomState} from "../models/websocket/room";
import {UserService} from "../services/user-service";

export class WsRoom {

    roomService: RoomService;
    userBoardService: UserBoardService;
    userService: UserService;

    constructor(roomProvider: RoomService, userBoardService: UserBoardService, userService: UserService, socket: any) {
        this.roomService = roomProvider;
        this.userBoardService = userBoardService;
        this.userService = userService;
        this.onDisconnect(socket);
        this.onFindRoom(socket);
        this.onJoinPrivateRoom(socket);
        this.onAcceptRoomInvite(socket);
        this.onCancelRoomInvite(socket);
    }

    onDisconnect(socket: any) {
        socket.on('disconnect', (reason: string) => {
            if (reason == 'server namespace disconnect') return; // kicked by the server

            const userId = WsConnection.getUserId(socket);
            console.log(`User ${userId} disconnected`)

            const room = this.roomService.removeUserFromRoom(userId);
            if (!room) return;
            if (room.started || room.users.length == 0) {
                this.emitRoomClosed(room)
;                console.log(`Room ${room.id} closed`);
            }
            this.userService.deleteSocketId(userId);
        })
    }

    onFindRoom(socket: any) {
        socket.on('find room', (ack: (response: RoomResponse) => void) => {
            this.findRoom(socket, ack, false);
        })
    }

    onJoinPrivateRoom(socket: any) {
        socket.on('private room', (userInvited: string, ack: (response: RoomResponse) => void) => {
            const userId = WsConnection.getUserId(socket);
            this.findRoom(socket, (response => {
                if (response.startFinding) {
                    const socketId = this.userService.getSocketId(userInvited);
                    if (socketId) {
                        this.userService.getUserById(userId).then(user => {
                            console.log(`User ${userId} invited ${userInvited} to a private room`);
                            io.to(socketId).emit('invite', {name: user.name, roomId: response.roomId});
                            if (ack) ack(response);
                        })
                    } else response.message = "User not connected";
                }
                if (ack) ack(response);
            }), true);
        });
    }
    
    onAcceptRoomInvite(socket: any) {
        socket.on('accept invite', (roomId: string, ack: (response: RoomResponse) => void) => {
            const userId = WsConnection.getUserId(socket);
            if(this.checkIfAlreadyInRoom(userId, ack)) {
                io.to(roomId).emit('invite failed', {message: 'User is already in a room'});
                return;
            }
            const room = this.roomService.getRoomById(roomId);
            if(room) {
                console.log(`User ${userId} accepted the invite`);
                if(ack) ack(new RoomResponse(true, 'entering room', roomId));
                room.users.push(userId);
                this.joinRoom(socket, room, userId);
            }
            if(ack) ack(new RoomResponse(false, 'No room found with that id'));
        });
    }
    
    onCancelRoomInvite(socket: any) {
        socket.on('cancel invite', (roomId: string) => {
            const room = this.roomService.getRoomById(roomId);
            if(room) {
                console.log(`Room ${room.id} invite canceled`);
                this.emitRoomClosed(room);
            }
        })
    }
    
    emitGameOver(room: Room, winnerId: string) {
        console.log(`Room ${room.id} closed`);
        console.log(`User ${winnerId} won!`);
        io.to(room.id).emit('game over', {winnerId: winnerId, loserId: room.users.filter(id => id != winnerId)[0]});
        this.deleteRoom(room);
    }

    private findRoom(socket: any, ack: (response: RoomResponse) => void, isPrivate: boolean) {
        const userId = WsConnection.getUserId(socket);
        
        if(this.checkIfAlreadyInRoom(userId, ack)) return;
        
        const room = this.roomService.getUserARoom(userId, isPrivate);
        if (ack) ack({startFinding: true, message: "User started looking for a room", roomId: room.id});

        this.joinRoom(socket, room, userId);
    }
    
    private joinRoom(socket: any, room: Room, userId: string) {
        socket.join(room.id);
        console.log(`User ${userId} joined room ${room.id}`)

        if (room.isFull()) {
            room.started = true;
            this.userBoardService.createUserBoards(room.users, room.id);
            io.to(room.id).emit('room opened', room.id);
            console.log(`Room ${room.id} opened`);
        }
    }
    
    private checkIfAlreadyInRoom(userId: string, ack: (response: RoomResponse) => void): boolean {
        if (this.roomService.getRoomByUserId(userId)) {
            console.log(`User ${userId} already in a room`);
            if (ack) ack({startFinding: false, message: "User already in a room", roomId: undefined});
            return true;
        }
        return false;
    }
    
    private emitRoomClosed(room: Room) {
        io.to(room.id).emit('room closed');
        this.deleteRoom(room);
    }
    
    private deleteRoom(room: Room) {
        room.roomState = RoomState.END;
        this.userBoardService.deleteUserBoardsByRoomId(room.id);
        this.roomService.deleteRoom(room.id);
    } 
}

class RoomResponse {
    constructor(public startFinding: boolean, public message: string, public roomId: string | undefined = undefined) {
    }
}

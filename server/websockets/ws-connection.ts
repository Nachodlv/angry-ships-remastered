import {io} from "../server/server";

export class WsConnection {
    

    connect(callback: (socket: any) => void) {
        const namespace = io.of('/');
        namespace.on('connection', (socket: any) => {
            const userId = WsConnection.getUserId(socket);
            console.log(`User connected with id: ${userId}`)
            callback(socket)
        });
    }

    static getUserId(socket: any): string {
        return socket.handshake.query.userId;
    }
}
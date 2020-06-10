import {DatabaseUser} from "../models/database/databaseUser";

export class UserProvider {
    
    usersWithNoRooms: string[] = [];
    usersWithSockets: Map<string, string> = new Map();
    
    getUserById(id: string): Promise<DatabaseUser> {
        return DatabaseUser.findByPk(id);
    }
    
    createUser(user: DatabaseUser): Promise<DatabaseUser> {
        return user.save();
    }
    
    addSocketIdToUser(userId: string, socketId: string) {
        this.usersWithSockets.set(userId, socketId);
    } 
    
    getSocketId(userId: string): string | undefined {
        return this.usersWithSockets.get(userId);
    }
    
    deleteSocketId(userId: string) {
        this.usersWithSockets.delete(userId);
    }
    
    updateUser(user: DatabaseUser): Promise<DatabaseUser> {
        return user.save();
    }
    
    addUserWithNoRoom(user: string) {
        this.usersWithNoRooms.push(user);
    }
    
    getNextUserWithNoRoom(): string | undefined{
        if(this.usersWithNoRooms.length == 0) return undefined;
        const user = this.usersWithNoRooms[0];
        this.usersWithNoRooms.shift();
        return user;
    }
}


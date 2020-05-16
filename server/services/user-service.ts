import {User} from '../models/user';

export class UserService {
    
    usersWithNoRooms: string[] = [];
    
    getUserById(id: string): Promise<User> {
        return User.findByPk(id);
    }
    
    createUser(user: User): Promise<User> {
        return User.create(user);
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


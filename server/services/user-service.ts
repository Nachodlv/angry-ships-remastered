import {User} from '../models/user';

export class UserService {
    
    getUserById(id: string): Promise<User> {
        return User.findByPk(id);
    }
    
    createUser(user: User): Promise<User> {
        return User.create(user);
    }
}


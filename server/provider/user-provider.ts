import {UserService} from "../services/user-service";
import {firebaseAdmin} from "../server/firebase-admin";
import {DatabaseUser} from "../models/database/databaseUser";
import {User} from "../models/user";

export class UserProvider {
    userService: UserService;

    constructor(userService: UserService) {
        this.userService = userService;
    }

    createUser(userId: string): Promise<DatabaseUser> {
        const user = DatabaseUser.build({id: userId});
        return this.userService.createUser(user);
    }
    
    getUserById(userId: string): Promise<User> {
        return this.userService.getUserById(userId).then(user =>
            firebaseAdmin.getUserById(userId).then(firebaseUser =>
                User.FromFirebaseAndDatabase(firebaseUser, user)
            )
        );
    }
}
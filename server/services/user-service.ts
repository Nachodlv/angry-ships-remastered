import {firebaseAdmin} from "../server/firebase-admin";
import {DatabaseUser} from "../models/database/databaseUser";
import {User} from "../models/user";
import {UserProvider} from "../providers/user-provider";

export class UserService {
    userProvider: UserProvider;

    constructor(userProvider: UserProvider) {
        this.userProvider = userProvider;
    }

    createUser(userId: string): Promise<DatabaseUser> {
        const user = DatabaseUser.build({id: userId});
        return this.userProvider.createUser(user);
    }
    
    getUserById(userId: string): Promise<User> {
        return this.userProvider.getUserById(userId).then(user =>
            firebaseAdmin.getUserById(userId).then(firebaseUser =>
                User.FromFirebaseAndDatabase(firebaseUser, user)
            )
        );
    }
    
    setSocketId(userId: string, socketId: string) {
        this.userProvider.addSocketIdToUser(userId, socketId);
    }
    
    getSocketId(userId: string): string | undefined {
        return this.userProvider.getSocketId(userId);
    }
    
    deleteSocketId(userId: string) {
        this.userProvider.deleteSocketId(userId);
    }
}
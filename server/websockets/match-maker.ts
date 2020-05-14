import {io} from "../server/server";

export class MatchMaker {
    
    namespace: any;
    
    constructor() {
        // io.on('connection', (socket: any) => {
        //     console.log('User connected!');
        //     socket.on('disconnect', () => {
        //         console.log('user disconnected');
        //     });
        // })
        this.namespace = io.of('/');    
        this.onConnection();
    }
    
    onConnection() {
        this.namespace.on('connection', (socket: any) => {
            console.log('User connected!')
            this.onMessage(socket);
            socket.on('disconnect', () => {
                console.log('user disconnected')
            })
        })
    }
    
    onMessage(socket: any) {
        socket.on('message', (message: Message) => {
            console.log(message);
        })
    } 
}

class Message {
    constructor(public text: string, public user: string) {}
}
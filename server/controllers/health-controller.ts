import {app} from "../server/server"

export class HealthController {
    init(): void {
        this.healthCheck();
    }
    
    healthCheck(): void {
        app.get("/", (req, res) => {
            res.send("Hello world")
        });
    }
}

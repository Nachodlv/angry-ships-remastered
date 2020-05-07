import {app} from "../server/server"

class HealthController {
    init(): void {
        this.healthCheck();
    }
    
    healthCheck(): void {
        app.get("/", (req, res) => {
            res.send("Hello world")
        });
    }
}

module.exports = HealthController;
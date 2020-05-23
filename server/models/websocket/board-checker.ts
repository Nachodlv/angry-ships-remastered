import {Boat, BoatType} from "./boat";

export class BoatChecker {
    private static quantitiesOfBoatType: Map<BoatType, number> = new Map<BoatType, number>([
        [BoatType.EXTRA_BIG, 1],
        [BoatType.BIG, 1],
        [BoatType.NORMAL, 2],
        [BoatType.SMALL, 3]
    ])

    static areBoatTypesValid(boats: Boat[]): boolean {
        for (const boatType of this.quantitiesOfBoatType) {
            let quantity = 0;
            for (const boat of boats) {
                if (boat.boatType == boatType[0]) quantity++;
            }
            if (quantity != boatType[1]) return false;
        }
        return true;
    }
}
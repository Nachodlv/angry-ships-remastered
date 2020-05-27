import {Boat, BoatType} from "./boat";


class BoatTypeDetails {
    constructor(public quantity: number, public height: number, public width: number) {
    }
}

export class BoatChecker {
    public static quantitiesOfBoatType: Map<BoatType, BoatTypeDetails> = new Map<BoatType, BoatTypeDetails>([
        [BoatType.EXTRA_BIG, new BoatTypeDetails(1, 5, 1)],
        [BoatType.BIG, new BoatTypeDetails(1, 4, 1)],
        [BoatType.NORMAL, new BoatTypeDetails(2, 3, 1)],
        [BoatType.SMALL, new BoatTypeDetails(3, 2, 1)]
    ])

    static areBoatTypesValid(boats: Boat[], maximumQuantityRequired: boolean): boolean {
        for (const boatType of this.quantitiesOfBoatType) {
            let quantity = 0;
            for (const boat of boats) {
                if (boat.boatType == boatType[0]) quantity++;
            }
            if (quantity > boatType[1].quantity || (maximumQuantityRequired && quantity < boatType[1].quantity)) 
                return false;
        }
        return true;
    }
}

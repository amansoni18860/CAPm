namespace asset.db;

using {
    cuid,
    managed
} from '@sap/cds/common';
using {employee.db as Employee} from './employee';

type AssetType   : String enum {
    LAPTOP = 'Laptop';
    DESKTOP = 'Desktop';
    MOBILE = 'Mobile';
    MONITOR = 'Monitor';
    TABLET = 'Tablet';
    VEHICLE = 'Vehicle';
    LICENSE = 'Software License';
    OTHER = 'Other';
}

type AssetStatus : String enum {
    AVAILABLE = 'Available';
    ASSIGNED = 'Assigned';
    IN_REPAIR = 'In Repair';
    LOST = 'Lost';
    RETIRED = 'Retired';
}

entity Assets : cuid, managed {

    assetCode       : String(20) not null;
    assetName       : localized String(100) not null;
    assetType       : AssetType not null;
    status          : AssetStatus not null;
    serialNumber    : String(50);
    purchaseDate    : Date;
    warrantyEndDate : Date;
    purchaseCost    : Decimal(15, 2);
    assignedTo      : Association to one Employee.Employee;
    vendor          : localized String(100);
    maintenanceHistory : Composition of many AssetMaintenance on maintenanceHistory.asset = $self;
}


entity AssetMaintenance : cuid {
    asset           : Association to Assets;
    serviceDate     : Date;
    serviceProvider : localized String(100);
    amount          : Decimal(15, 2);
    remarks         : localized String(500);

}

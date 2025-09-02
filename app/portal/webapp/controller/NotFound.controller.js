sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
    "use strict";

    return Controller.extend("portal.controller.NotFound", {
        onNavBack: function () {
            this.getOwnerComponent().getRouter().navTo("RouteLogin", {}, true);
        }
    });
});

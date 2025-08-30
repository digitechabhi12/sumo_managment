sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";
    return Controller.extend("portal.controller.dashboard", {
        onInit: function () {
            this._loadViewBasedOnRole();
        },
        _loadViewBasedOnRole: function () {  
            var sRole = "Admin";
            var oModel = new JSONModel({
                userRole: sRole
            });
            this.getView().setModel(oModel, "user");
            var oContainer = this.byId("viewContainer");
            var oExistingView = oContainer.getItems().find(function (item) {
                return item.getId() === "Main" + sRole;
            });

            if (oExistingView) {
                oExistingView.setVisible(true);
            } else {
                
                var oView = sap.ui.view({
                    id: "Main" + sRole,
                    viewName: "portal.view." + sRole + "." + sRole,
                    type: "XML"
                });
                oContainer.addItem(oView);
            }
            oContainer.getItems().forEach(function (oItem) {
                if (oItem.getId() !== "Main" + sRole) {
                    oItem.setVisible(false);
                }
            });
        }
    });
});

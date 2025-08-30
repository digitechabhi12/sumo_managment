sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/Popover",
    "sap/m/NotificationListItem",
    "sap/m/NotificationList",
    "sap/m/Dialog",
    "sap/m/Text"
], function (Controller, Popover, NotificationListItem, NotificationList, Dialog, Text) {
    "use strict";

    return Controller.extend("portal.controller.Admin", {

        onInit: function () {
            // Initialization logic if needed
        },

        onNotificationPress: function () {
            var oPopover = this.byId("notificationPopover");

            // Open the popover if it is not already open
            if (!oPopover) {
                oPopover = new Popover({
                    id: "notificationPopover",
                    placement: "Right",
                    horizontalOffset: 10,
                    content: [
                        new NotificationList({
                            items: [
                                new NotificationListItem({
                                    title: "Mail Subject 1",
                                    description: "Sender: John Doe",
                                    content: new Text({ text: "2025-09-01 10:00 AM" })
                                }),
                                new NotificationListItem({
                                    title: "Mail Subject 2",
                                    description: "Sender: Jane Smith",
                                    content: new Text({ text: "2025-09-02 02:00 PM" })
                                }),
                                new NotificationListItem({
                                    title: "Mail Subject 3",
                                    description: "Sender: Mark Johnson",
                                    content: new Text({ text: "2025-09-03 05:30 PM" })
                                })
                            ]
                        })
                    ]
                });
                this.getView().addDependent(oPopover);
            }

            oPopover.openBy(this.byId("notificationButton"));
        },

        onDateSelect: function (oEvent) {
            var oSelectedDate = oEvent.getParameter("date");
            var sDate = oSelectedDate.toString(); // Get the selected date
            var oDialog = new Dialog({
                title: "Meeting Details for " + sDate,
                content: [
                    new Text({ text: "Meeting on " + sDate }),
                    new Text({ text: "Details: Example meeting on the selected date." })
                ],
                beginButton: new sap.m.Button({
                    text: "Close",
                    press: function () {
                        oDialog.close();
                    }
                })
            });
            oDialog.open();
        }

    });
});

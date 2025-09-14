sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/ui/core/BusyIndicator"
], function (Controller, MessageToast, MessageBox, BusyIndicator) {
    "use strict";

    return Controller.extend("portal.controller.login", {

        onInit: function () {
            this._email = "";
            this._resendTimer = null;
        },

        onSendOTP: function () {
            const oView = this.getView();
            const oModel = this.getOwnerComponent().getModel();
            const sEmail = oView.byId("emailInput").getValue();

            if (!sEmail) {
                MessageToast.show("Please enter your email.");
                return;
            }

            this._email = sEmail.toLowerCase();
            BusyIndicator.show(0);

            oModel.callFunction("/loginCheck", {
                method: "POST",
                urlParameters: {
                    email: this._email
                },
                success: (oData) => {
                    BusyIndicator.hide();

                    const response = oData?.loginCheck;
                    if (response?.message) {
                        MessageToast.show(response.message);
                        this._toggleOTPUI(true);
                        this._startResendTimer();
                    }
                },
                error: () => {
                    BusyIndicator.hide();
                    MessageBox.error("Failed to send OTP.");
                }
            });
        },

        onVerifyOTP: function () {
            const oView = this.getView();
            const oModel = this.getOwnerComponent().getModel();
            const sOTP = oView.byId("otpInput").getValue();

            if (!sOTP) {
                MessageToast.show("Please enter the OTP.");
                return;
            }

            BusyIndicator.show(0);

            oModel.callFunction("/loginCheck", {
                method: "POST",
                urlParameters: {
                    email: this._email,
                    otp: sOTP
                },
                success: (oData) => {
                    BusyIndicator.hide();

                    const response = oData?.loginCheck;
                    if (response?.token) {
                        MessageToast.show("Login successful!");
                        sessionStorage.setItem("token", response.token);
                        this.getOwnerComponent().getRouter().navTo("Routedashboard");
                    } else if (response?.message) {
                        MessageToast.show(response.message);
                    }
                },
                error: () => {
                    BusyIndicator.hide();
                    MessageBox.error("OTP verification failed.");
                }
            });
        },

        onResendOTP: function () {
            const oModel = this.getOwnerComponent().getModel();

            BusyIndicator.show(0);

            oModel.callFunction("/loginCheck", {
                method: "POST",
                urlParameters: {
                    email: this._email,
                    action: "resend"
                },
                success: (oData) => {
                    BusyIndicator.hide();

                    const response = oData?.loginCheck;
                    if (response?.message) {
                        MessageToast.show(response.message);
                        this._startResendTimer();
                    }
                },
                error: () => {
                    BusyIndicator.hide();
                    MessageBox.error("Failed to resend OTP.");
                }
            });
        },

        _toggleOTPUI: function (bVisible) {
            const oView = this.getView();

            oView.byId("otpInput").setVisible(bVisible);
            oView.byId("otpInput").setValue("");

            oView.byId("btnVerifyOTP").setVisible(bVisible);
            oView.byId("btnResendOTP").setVisible(bVisible);
            oView.byId("btnSendOTP").setVisible(!bVisible);
        },

        _startResendTimer: function () {
            const oView = this.getView();
            const oResendBtn = oView.byId("btnResendOTP");

            oResendBtn.setEnabled(false);

            if (this._resendTimer) {
                clearTimeout(this._resendTimer);
            }

            this._resendTimer = setTimeout(() => {
                oResendBtn.setEnabled(true);
            }, 10000); 
        },
        _clearLoginData: function () {
    const oView = this.getView();

    oView.byId("emailInput").setValue("");
    oView.byId("otpInput").setValue("").setVisible(false);
    oView.byId("btnSendOTP").setVisible(true);
    oView.byId("btnVerifyOTP").setVisible(false);
    oView.byId("btnResendOTP").setVisible(false).setEnabled(false);
    this._email = "";
    if (this._resendTimer) {
        clearTimeout(this._resendTimer);
        this._resendTimer = null;
    }
}

    });
});

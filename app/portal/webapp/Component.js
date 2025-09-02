sap.ui.define(
  ["sap/ui/core/UIComponent", "portal/model/models"],
  function (UIComponent, models) {
    "use strict";

    return UIComponent.extend("portal.Component", {
      metadata: {
        manifest: "json",
        interfaces: ["sap.ui.core.IAsyncContentCreation"],
      },

      init: function () {
        UIComponent.prototype.init.apply(this, arguments);

        this.setModel(models.createDeviceModel(), "device");

        const oRouter = this.getRouter();

        // Listen for all unmatched routes
        oRouter.attachBypassed(this._onBypassed, this);

        // Check auth before navigating
        oRouter.attachBeforeRouteMatched(this._onBeforeRouteMatched, this);

        oRouter.initialize();
      },

      /**
       * Called if no matching route is found (invalid URL).
       */
      _onBypassed: function () {
        this.getRouter().navTo("RouteNotFound", {}, true);
      },

      /**
       * Protect routes like 'dashboard' if not logged in.
       */
      _onBeforeRouteMatched: function (oEvent) {
        const sRouteName = oEvent.getParameter("name");
        const bIsLoginRoute =
          sRouteName === "RouteLogin" || sRouteName === "RouteNotFound";
        const token = window.sessionStorage.getItem("token");

        // If user is not authenticated and tries to access protected route, block it.
        if (token === null && bIsLoginRoute === false) {
          oEvent.preventDefault(); // Cancel route
          this.getRouter().navTo("RouteLogin", {}, true); // Redirect to login
        }
      },
    });
  }
);

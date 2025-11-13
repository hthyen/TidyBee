// src/services/adminService.js
import bookingService from "./bookingService";
import paymentService from "./payment";
import userService from "./userService";

const adminService = {
  async getDashboardStats() {
    try {
      const [bookings, payments, users] = await Promise.all([
        bookingService.getAllBookings(),
        paymentService.getAllPayments(),
        userService.getAllUsers(),
      ]);

      const totalUsers = users.length;
      const activeOrders = bookings.filter((b) => b.status === "Active").length;
      const completedOrders = bookings.filter(
        (b) => b.status === "Completed"
      ).length;
      const totalRevenue = payments.reduce(
        (sum, p) => sum + (p.amount || 0),
        0
      );

      return {
        totalUsers,
        activeOrders,
        completedOrders,
        totalRevenue,
      };
    } catch (error) {
      console.error("❌ Error fetching dashboard stats:", error);
      throw error;
    }
  },
};

export default adminService;

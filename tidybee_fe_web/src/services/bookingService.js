import axios from "axios";

const BASE_URL = import.meta.env.VITE_BOOKING_API + "/Bookings/admin";

export const bookingService = {
  // 🟢 Lấy tất cả bookings
  getAll: async (page = 1, pageSize = 20) => {
    const token = localStorage.getItem("token");
    const res = await axios.get(
      `${BASE_URL}/all?page=${page}&pageSize=${pageSize}`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    return res.data;
  },

  // 🟡 Cập nhật trạng thái booking (force update)
  updateStatus: async (id, newStatus) => {
    const token = localStorage.getItem("token");
    const res = await axios.patch(
      `${BASE_URL}/${id}/status`,
      { status: newStatus },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    return res.data;
  },

  // 🔵 Lấy thống kê booking (cho dashboard)
  getStatistics: async () => {
    const token = localStorage.getItem("token");
    const res = await axios.get(`${BASE_URL}/statistics`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    return res.data;
  },
};

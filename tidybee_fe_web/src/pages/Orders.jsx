// src/pages/Orders.jsx
import React, { useEffect, useState } from "react";
import axios from "axios";

export default function Orders() {
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  const API_BASE_URL = "http://3.26.243.72:8080/api";

  // ✅ Gọi API lấy danh sách bookings (dành cho admin)
  useEffect(() => {
    const fetchBookings = async () => {
      try {
        const token = localStorage.getItem("token"); // token admin
        const res = await axios.get(`${API_BASE_URL}/Bookings`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setOrders(res.data || []);
      } catch (error) {
        console.error("❌ Lỗi khi lấy danh sách bookings:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchBookings();
  }, []);

  // ✅ Lọc dữ liệu hiển thị
  const filteredOrders = orders.filter((order) => {
    const matchesSearch =
      order.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      order.customer?.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      order.helper?.name?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter ? order.status === statusFilter : true;
    return matchesSearch && matchesStatus;
  });

  // ✅ Cập nhật trạng thái booking
  const handleUpdateStatus = async (id, newStatus) => {
    try {
      const token = localStorage.getItem("token");
      await axios.put(
        `${API_BASE_URL}/Bookings/${id}`,
        { status: newStatus },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      setOrders((prev) =>
        prev.map((o) => (o.id === id ? { ...o, status: newStatus } : o))
      );
      alert(`✅ Đã cập nhật trạng thái booking ${id} thành ${newStatus}`);
    } catch (err) {
      console.error("❌ Lỗi cập nhật trạng thái:", err);
      alert("Không thể cập nhật trạng thái booking.");
    }
  };

  // ✅ Xoá / huỷ booking
  const handleDelete = async (id) => {
    if (!window.confirm(`Bạn có chắc muốn xoá booking ${id}?`)) return;
    try {
      const token = localStorage.getItem("token");
      await axios.delete(`${API_BASE_URL}/Bookings/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setOrders((prev) => prev.filter((o) => o.id !== id));
      alert(`🗑️ Booking ${id} đã được xoá.`);
    } catch (err) {
      console.error("❌ Lỗi xoá booking:", err);
      alert("Không thể xoá booking này.");
    }
  };

  if (loading) return <p className="p-6">Đang tải dữ liệu...</p>;

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">
        Bookings Management (Admin)
      </h1>

      {/* Bộ lọc */}
      <div className="mb-6 flex flex-wrap gap-4 items-center">
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="border px-4 py-2 rounded-lg"
        >
          <option value="">All Status</option>
          <option value="Pending">Pending</option>
          <option value="Accepted">Accepted</option>
          <option value="InProgress">In Progress</option>
          <option value="Completed">Completed</option>
          <option value="Cancelled">Cancelled</option>
        </select>

        <input
          type="text"
          placeholder="Tìm kiếm booking..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="px-4 py-2 border rounded-lg shadow-sm focus:ring focus:ring-green-200 focus:border-green-400"
        />
      </div>

      {/* Bảng hiển thị */}
      <div className="overflow-x-auto bg-white rounded-lg shadow">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700">
            <tr>
              <th className="p-3 text-left">ID</th>
              <th className="p-3 text-left">Customer</th>
              <th className="p-3 text-left">Helper</th>
              <th className="p-3 text-left">Service</th>
              <th className="p-3 text-left">Start</th>
              <th className="p-3 text-left">End</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredOrders.length === 0 ? (
              <tr>
                <td colSpan="8" className="text-center p-6 text-gray-500">
                  Không có booking nào.
                </td>
              </tr>
            ) : (
              filteredOrders.map((order) => (
                <tr
                  key={order.id}
                  className="border-t hover:bg-gray-50 transition"
                >
                  <td className="p-3">{order.id}</td>
                  <td className="p-3">{order.customer?.name || "—"}</td>
                  <td className="p-3">{order.helper?.name || "—"}</td>
                  <td className="p-3">{order.title}</td>
                  <td className="p-3">
                    {new Date(order.scheduledStartTime).toLocaleString()}
                  </td>
                  <td className="p-3">
                    {new Date(order.scheduledEndTime).toLocaleString()}
                  </td>
                  <td className="p-3">
                    <span
                      className={`px-2 py-1 rounded-full text-sm font-medium ${
                        order.status === "Completed"
                          ? "bg-green-100 text-green-700"
                          : order.status === "Pending"
                          ? "bg-orange-100 text-orange-700"
                          : order.status === "Cancelled"
                          ? "bg-red-100 text-red-700"
                          : "bg-gray-100 text-gray-700"
                      }`}
                    >
                      {order.status}
                    </span>
                  </td>
                  <td className="p-3 flex flex-col gap-1 items-center">
                    <button
                      onClick={() => alert(JSON.stringify(order, null, 2))}
                      className="text-blue-600 hover:underline"
                    >
                      View
                    </button>
                    {order.status !== "Completed" && (
                      <button
                        onClick={() =>
                          handleUpdateStatus(order.id, "Completed")
                        }
                        className="text-green-600 hover:underline"
                      >
                        Complete
                      </button>
                    )}
                    <button
                      onClick={() => handleDelete(order.id)}
                      className="text-red-600 hover:underline"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// src/pages/Orders.jsx
import React, { useState } from "react";

export default function Orders() {
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [orders, setOrders] = useState([
    {
      id: "o001",
      customer: "Mai",
      cleaner: "Hằng",
      service: "Lau nhà",
      date: "2025-10-15",
      time: "09:00",
      status: "Completed",
      total: 120,
    },
    {
      id: "o002",
      customer: "Lan",
      cleaner: "Hùng",
      service: "Dọn bếp",
      date: "2025-10-16",
      time: "14:00",
      status: "Pending",
      total: 80,
    },
    {
      id: "o003",
      customer: "Hà",
      cleaner: "Tuấn",
      service: "Giặt rèm",
      date: "2025-10-17",
      time: "10:00",
      status: "Canceled",
      total: 50,
    },
  ]);

  const filteredOrders = orders.filter(
    (order) =>
      (order.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.cleaner.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.service.toLowerCase().includes(searchTerm.toLowerCase())) &&
      (statusFilter ? order.status === statusFilter : true)
  );

  const handleUpdateStatus = (id, newStatus) => {
    setOrders(
      orders.map((order) =>
        order.id === id ? { ...order, status: newStatus } : order
      )
    );
  };

  const handleRefund = (id) => {
    setOrders(
      orders.map((order) =>
        order.id === id ? { ...order, status: "Refunded" } : order
      )
    );
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">Orders Management</h1>

      {/* Filters */}
      <div className="mb-6 flex flex-wrap gap-4 items-center">
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="border px-4 py-2 rounded-lg"
        >
          <option value="">All Status</option>
          <option value="Pending">Pending</option>
          <option value="Completed">Completed</option>
          <option value="Canceled">Canceled</option>
          <option value="Refunded">Refunded</option>
        </select>

        <input
          type="text"
          placeholder="Search orders..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="px-4 py-2 border rounded-lg shadow-sm focus:ring focus:ring-green-200 focus:border-green-400"
        />
      </div>

      {/* Orders Table */}
      <div className="overflow-x-auto bg-white rounded-lg shadow">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700">
            <tr>
              <th className="p-3 text-left">ID</th>
              <th className="p-3 text-left">Customer</th>
              <th className="p-3 text-left">Cleaner</th>
              <th className="p-3 text-left">Service</th>
              <th className="p-3 text-left">Date</th>
              <th className="p-3 text-left">Time</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-left">Total</th>
              <th className="p-3 text-center">Action</th>
            </tr>
          </thead>
          <tbody>
            {filteredOrders.map((order) => (
              <tr key={order.id} className="border-t hover:bg-gray-50 transition">
                <td className="p-3">{order.id}</td>
                <td className="p-3">{order.customer}</td>
                <td className="p-3">{order.cleaner}</td>
                <td className="p-3">{order.service}</td>
                <td className="p-3">{order.date}</td>
                <td className="p-3">{order.time}</td>
                <td className="p-3">
                  <span
                    className={`px-2 py-1 rounded-full text-sm font-medium ${
                      order.status === "Completed"
                        ? "bg-green-100 text-green-700"
                        : order.status === "Pending"
                        ? "bg-orange-100 text-orange-700"
                        : "bg-red-100 text-red-700"
                    }`}
                  >
                    {order.status}
                  </span>
                </td>
                <td className="p-3">${order.total}</td>
                <td className="p-3 text-center flex flex-col gap-1 items-center">
                  <button
                    onClick={() => alert(`View details of ${order.id}`)}
                    className="text-blue-600 hover:underline"
                  >
                    View
                  </button>
                  <button
                    onClick={() => handleUpdateStatus(order.id, "Completed")}
                    className="text-green-600 hover:underline"
                  >
                    Complete
                  </button>
                  <button
                    onClick={() => handleRefund(order.id)}
                    className="text-red-600 hover:underline"
                  >
                    Refund
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

import React, { useEffect } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  Legend,
  PieChart,
  Pie,
  Cell,
} from "recharts";

export default function AdminDashboard() {
  useEffect(() => {
    const token = localStorage.getItem("token");
    if (!token) {
      window.location.href = "/";
    }
  }, []);

  const revenueData = [
    { day: "15-10", revenue: 120 },
    { day: "16-10", revenue: 150 },
    { day: "17-10", revenue: 90 },
    { day: "18-10", revenue: 200 },
  ];

  const orderStatusData = [
    { name: "Completed", value: 89 },
    { name: "Active", value: 35 },
    { name: "Pending", value: 12 },
    { name: "Canceled", value: 5 },
  ];

  const COLORS = ["#22c55e", "#3b82f6", "#f59e0b", "#ef4444"];

  return (
    <div className="p-6">
      <main className="flex-1 p-6 overflow-y-auto">
        <h1 className="text-3xl font-bold text-gray-800 mb-6">
          Tổng quan hệ thống
        </h1>

        {/* Thẻ thống kê */}
        <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-5 rounded-2xl shadow hover:shadow-lg transition">
            <h3 className="text-gray-500">Tổng số người dùng</h3>
            <p className="text-3xl font-semibold text-green-600 mt-2">120</p>
          </div>

          <div className="bg-white p-5 rounded-2xl shadow hover:shadow-lg transition">
            <h3 className="text-gray-500">Đơn đang hoạt động</h3>
            <p className="text-3xl font-semibold text-green-600 mt-2">35</p>
          </div>

          <div className="bg-white p-5 rounded-2xl shadow hover:shadow-lg transition">
            <h3 className="text-gray-500">Đơn đã hoàn thành</h3>
            <p className="text-3xl font-semibold text-green-600 mt-2">89</p>
          </div>

          <div className="bg-white p-5 rounded-2xl shadow hover:shadow-lg transition">
            <h3 className="text-gray-500">Doanh thu tháng</h3>
            <p className="text-3xl font-semibold text-green-600 mt-2">$4,200</p>
          </div>
        </section>

        {/* Biểu đồ */}
        <section className="mt-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Doanh thu theo ngày */}
          <div className="bg-white p-6 rounded-2xl shadow">
            <h2 className="text-xl font-semibold mb-4 text-gray-700">
              Doanh thu theo ngày
            </h2>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={revenueData}>
                  <XAxis dataKey="day" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="revenue" fill="#22c55e" />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Số đơn theo trạng thái */}
          <div className="bg-white p-6 rounded-2xl shadow">
            <h2 className="text-xl font-semibold mb-4 text-gray-700">
              Số đơn theo trạng thái
            </h2>
            <div className="h-64 flex items-center justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={orderStatusData}
                    dataKey="value"
                    nameKey="name"
                    cx="50%"
                    cy="50%"
                    outerRadius={80}
                    fill="#8884d8"
                    label
                  >
                    {orderStatusData.map((entry, index) => (
                      <Cell
                        key={`cell-${index}`}
                        fill={COLORS[index % COLORS.length]}
                      />
                    ))}
                  </Pie>
                  <Tooltip />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}

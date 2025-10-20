// src/pages/Payments.jsx
import React, { useState } from "react";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Legend } from "recharts";

export default function Payments() {
  const [filterMethod, setFilterMethod] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [payments, setPayments] = useState([
    { id: "p001", order: "o001", customer: "Mai", amount: 120, status: "Paid", date: "2025-10-15", method: "Credit Card" },
    { id: "p002", order: "o002", customer: "Lan", amount: 80, status: "Pending", date: "2025-10-16", method: "Cash" },
    { id: "p003", order: "o003", customer: "Hà", amount: 50, status: "Paid", date: "2025-10-17", method: "Credit Card" },
  ]);

  const filteredPayments = payments.filter(p => {
    const pDate = new Date(p.date);
    const start = startDate ? new Date(startDate) : null;
    const end = endDate ? new Date(endDate) : null;
    return (
      (!filterMethod || p.method === filterMethod) &&
      (!start || pDate >= start) &&
      (!end || pDate <= end)
    );
  });

  // Demo data cho chart
  const chartData = [
    { day: "15-10", revenue: 120 },
    { day: "16-10", revenue: 80 },
    { day: "17-10", revenue: 50 },
  ];

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">Payments / Revenue</h1>

      {/* Filters */}
      <div className="mb-6 flex flex-wrap gap-4 items-center">
        <input
          type="date"
          value={startDate}
          onChange={e => setStartDate(e.target.value)}
          className="px-4 py-2 border rounded-lg"
        />
        <input
          type="date"
          value={endDate}
          onChange={e => setEndDate(e.target.value)}
          className="px-4 py-2 border rounded-lg"
        />
        <select
          value={filterMethod}
          onChange={e => setFilterMethod(e.target.value)}
          className="px-4 py-2 border rounded-lg"
        >
          <option value="">All Methods</option>
          <option value="Credit Card">Credit Card</option>
          <option value="Cash">Cash</option>
        </select>
      </div>

      {/* Payments Table */}
      <div className="overflow-x-auto bg-white rounded-lg shadow mb-6">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700">
            <tr>
              <th className="p-3 text-left">ID</th>
              <th className="p-3 text-left">Order</th>
              <th className="p-3 text-left">Customer</th>
              <th className="p-3 text-left">Amount</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-left">Date</th>
              <th className="p-3 text-left">Method</th>
            </tr>
          </thead>
          <tbody>
            {filteredPayments.map(p => (
              <tr key={p.id} className="border-t hover:bg-gray-50 transition">
                <td className="p-3">{p.id}</td>
                <td className="p-3">{p.order}</td>
                <td className="p-3">{p.customer}</td>
                <td className="p-3">{p.amount}k</td>
                <td className="p-3">
                  <span
                    className={`px-2 py-1 rounded-full text-sm font-medium ${
                      p.status === "Paid"
                        ? "bg-green-100 text-green-700"
                        : "bg-orange-100 text-orange-700"
                    }`}
                  >
                    {p.status}
                  </span>
                </td>
                <td className="p-3">{p.date}</td>
                <td className="p-3">{p.method}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Revenue Chart */}
      <section className="bg-white p-6 rounded-2xl shadow">
        <h2 className="text-xl font-semibold mb-4 text-gray-700">Daily Revenue</h2>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData}>
              <XAxis dataKey="day" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="revenue" fill="#22c55e" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </section>
    </div>
  );
}

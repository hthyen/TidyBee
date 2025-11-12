import React, { useEffect, useState, useMemo } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from "recharts";
import { getMyTransactions } from "../services/payment";
import axios from "axios";

export default function Payments() {
  const [transactions, setTransactions] = useState([]);
  const [users, setUsers] = useState({});
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [pageSize] = useState(20);
  const [totalPages, setTotalPages] = useState(1);

  const token = localStorage.getItem("token");

  // ⚡️ Lấy danh sách người dùng
  const fetchUsers = async () => {
    try {
      const res = await axios.get(
        "https://handbags-cst-isp-smooth.trycloudflare.com/api/Users?page=1&pageSize=100"
      );
      const map = {};
      res.data?.data?.forEach((u) => {
        map[String(u.id)] = u.fullName || u.userName || "Không rõ";
      });
      setUsers(map);
    } catch (err) {
      console.error("❌ Lỗi tải danh sách user:", err);
    }
  };

  // ⚡️ Lấy danh sách giao dịch
  const fetchTransactions = async (pageNum = 1) => {
    try {
      setLoading(true);
      const { transactions, totalPages } = await getMyTransactions(
        token,
        pageNum,
        pageSize
      );
      setTransactions(transactions);
      setPage(pageNum);
      setTotalPages(totalPages);
    } catch (err) {
      console.error("❌ Lỗi tải danh sách giao dịch:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
    fetchTransactions();
  }, []);

  // 🧮 Tính toán thống kê
  const stats = useMemo(() => {
    return {
      totalRevenue: transactions.reduce((s, t) => s + (t.amount || 0), 0),
      totalPlatformFees: transactions.reduce(
        (s, t) => s + (t.platformFee || 0),
        0
      ),
      totalHelperEarnings: transactions.reduce(
        (s, t) => s + (t.helperAmount || 0),
        0
      ),
      totalRefunds: transactions.reduce((s, t) => s + (t.refundAmount || 0), 0),
    };
  }, [transactions]);

  // 📊 Chuẩn hóa dữ liệu biểu đồ
  const chartData = useMemo(() => {
    const acc = [];
    transactions.forEach((t) => {
      const day = new Date(t.createdAt).toLocaleDateString("vi-VN", {
        day: "2-digit",
        month: "2-digit",
      });
      const found = acc.find((a) => a.day === day);
      if (found) found.revenue += t.amount || 0;
      else acc.push({ day, revenue: t.amount || 0 });
    });
    return acc.sort(
      (a, b) =>
        new Date(a.day.split("/").reverse().join("-")) -
        new Date(b.day.split("/").reverse().join("-"))
    );
  }, [transactions]);

  // 🔠 Hàm helper hiển thị phương thức thanh toán
  const getPaymentMethodLabel = (method) => {
    switch (method) {
      case 1:
        return "Tiền mặt ";
      case 4:
        return "Chuyển khoản";
      default:
        return "Khác";
    }
  };

  // 🔠 Hàm helper hiển thị trạng thái tiếng Việt + màu sắc
  const getStatusInfo = (status) => {
    switch (status) {
      case 1:
        return {
          label: "Đang chờ xử lý",
          color: "bg-yellow-100 text-yellow-700",
        };
      case 2:
        return { label: "Đang xử lý", color: "bg-blue-100 text-blue-700" };
      case 3:
        return { label: "Hoàn tất", color: "bg-green-100 text-green-700" };
      case 4:
        return { label: "Thất bại", color: "bg-red-100 text-red-700" };
      case 5:
        return {
          label: "Đã hoàn tiền",
          color: "bg-orange-100 text-orange-700",
        };
      case 6:
        return {
          label: "Giữ hộ (ký quỹ)",
          color: "bg-purple-100 text-purple-700",
        };
      default:
        return { label: "Không rõ", color: "bg-gray-100 text-gray-700" };
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">
        💰 Quản lý Thanh toán
      </h1>

      {/* Thống kê */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <Card label="Tổng doanh thu" value={stats.totalRevenue} color="green" />
        <Card
          label="Phí nền tảng"
          value={stats.totalPlatformFees}
          color="red"
        />
        <Card
          label="Thu nhập cộng tác viên"
          value={stats.totalHelperEarnings}
          color="blue"
        />
        <Card label="Hoàn tiền" value={stats.totalRefunds} color="orange" />
      </div>

      {/* Bảng giao dịch */}
      <div className="overflow-x-auto bg-white rounded-lg shadow mb-6">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700 text-sm">
            <tr>
              <th className="p-3 text-left">#</th>
              <th className="p-3 text-left">Mã đặt</th>
              <th className="p-3 text-left">Khách hàng</th>
              <th className="p-3 text-left">Số tiền</th>
              <th className="p-3 text-left">Trạng thái</th>
              <th className="p-3 text-left">Ngày</th>
              <th className="p-3 text-left">Phương thức</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={7} className="text-center p-4 italic">
                  ⏳ Đang tải dữ liệu...
                </td>
              </tr>
            ) : transactions.length ? (
              transactions.map((t, i) => (
                <tr
                  key={t.id}
                  className="border-t hover:bg-gray-50 transition text-sm"
                >
                  <td className="p-3 text-gray-600">{i + 1}</td>
                  <td className="p-3">{t.bookingRequestId || "--"}</td>
                  <td className="p-3 font-medium text-gray-900">
                    {users[String(t.customerId)] ? (
                      users[String(t.customerId)]
                    ) : (
                      <span className="text-gray-400 italic">
                        #{String(t.customerId)?.slice(0, 6)}...
                      </span>
                    )}
                  </td>

                  <td className="p-3 text-green-700 font-semibold">
                    {(t.amount || 0).toLocaleString()} đ
                  </td>
                  <td className="p-3">
                    {(() => {
                      const { label, color } = getStatusInfo(t.status);
                      return (
                        <span
                          className={`px-2 py-1 rounded-full text-xs font-semibold ${color}`}
                        >
                          {label}
                        </span>
                      );
                    })()}
                  </td>

                  <td className="p-3 text-gray-500">
                    {new Date(t.createdAt).toLocaleDateString("vi-VN")}
                  </td>
                  <td className="p-3">
                    <span
                      className={`px-2 py-1 rounded-full text-xs font-medium ${
                        t.paymentMethod === 1
                          ? "bg-yellow-100 text-yellow-700"
                          : t.paymentMethod === 4
                          ? "bg-blue-100 text-blue-700"
                          : "bg-gray-100 text-gray-700"
                      }`}
                    >
                      {getPaymentMethodLabel(t.paymentMethod)}
                    </span>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan={7}
                  className="text-center p-4 italic text-gray-500"
                >
                  Không có dữ liệu giao dịch
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Phân trang */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-3 mb-6">
          <button
            disabled={page <= 1}
            onClick={() => fetchTransactions(page - 1)}
            className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
          >
            ← Trước
          </button>
          <span className="text-gray-700">
            Trang {page}/{totalPages}
          </span>
          <button
            disabled={page >= totalPages}
            onClick={() => fetchTransactions(page + 1)}
            className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
          >
            Sau →
          </button>
        </div>
      )}

      {/* Biểu đồ doanh thu */}
      <section className="bg-white p-6 rounded-2xl shadow">
        <h2 className="text-xl font-semibold mb-4 text-gray-700">
          Biểu đồ doanh thu theo ngày
        </h2>
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

// 🧩 Component Card tái sử dụng
function Card({ label, value, color }) {
  return (
    <div className="bg-white p-4 rounded-xl shadow text-center">
      <p className="text-gray-500">{label}</p>
      <p className={`text-xl font-bold text-${color}-600`}>
        {value.toLocaleString()} đ
      </p>
    </div>
  );
}

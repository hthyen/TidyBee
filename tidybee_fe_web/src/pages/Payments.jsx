import React, { useEffect, useState, useMemo } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
} from "recharts";
import { getMyTransactions } from "../services/payment";

export default function Payments() {
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [pageSize] = useState(5);
  const [totalPages, setTotalPages] = useState(1);

  const token = localStorage.getItem("token");

  // 🔹 Lấy danh sách giao dịch với phân trang
  const fetchTransactions = async (pageNum = 1) => {
    try {
      setLoading(true);
      const res = await getMyTransactions(token, pageNum, pageSize);
      console.log("API response:", res);

      // Chọn đúng dữ liệu
      const data = res.transactions || res.data || [];
      const totalItems = res.totalItems ?? data.length;

      setTransactions(data);
      setPage(pageNum);
      setTotalPages(Math.ceil(totalItems / pageSize) || 1);
    } catch (err) {
      console.error("❌ Lỗi tải danh sách giao dịch:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTransactions(1);
  }, []);

  // 🔹 Tính toán thống kê
  const stats = useMemo(
    () => ({
      totalRevenue: transactions.reduce(
        (s, t) => s + (Number(t.amount) || 0),
        0
      ),
      totalPlatformFees: transactions.reduce(
        (s, t) => s + (Number(t.platformFee) || 0),
        0
      ),
      totalHelperEarnings: transactions.reduce(
        (s, t) => s + (Number(t.helperAmount) || 0),
        0
      ),
      totalRefunds: transactions.reduce(
        (s, t) => s + (Number(t.refundAmount) || 0),
        0
      ),
    }),
    [transactions]
  );

  // 🔹 Chuẩn hóa dữ liệu biểu đồ 7 ngày gần nhất
  const chartData = useMemo(() => {
    const today = new Date();

    // 7 ngày gần nhất (cũ → mới)
    const last7Days = Array.from({ length: 7 }, (_, i) => {
      const d = new Date(today);
      d.setDate(today.getDate() - (6 - i));
      return d.toLocaleDateString("vi-VN", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      });
    });

    const acc = last7Days.map((day) => ({ day, revenue: 0 }));

    transactions.forEach((t) => {
      const createdAt = new Date(t.createdAt);
      if (isNaN(createdAt)) return; // bỏ qua ngày không hợp lệ

      const day = createdAt.toLocaleDateString("vi-VN", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      });

      const found = acc.find((a) => a.day === day);
      if (found) found.revenue += Number(t.amount) || 0;
    });

    return acc;
  }, [transactions]);

  // 🔹 Hiển thị phương thức thanh toán
  const getPaymentMethodLabel = (method) => {
    switch (method) {
      case 1:
        return "Tiền mặt";
      case 4:
        return "Chuyển khoản";
      default:
        return "Khác";
    }
  };

  // 🔹 Hiển thị trạng thái
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
              <th className="p-3 text-left">Người hỗ trợ</th>
              <th className="p-3 text-left">Số tiền</th>
              <th className="p-3 text-left">Trạng thái</th>
              <th className="p-3 text-left">Ngày</th>
              <th className="p-3 text-left">Phương thức</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={8} className="text-center p-4 italic">
                  ⏳ Đang tải dữ liệu...
                </td>
              </tr>
            ) : transactions.length ? (
              transactions.map((t, i) => (
                <tr
                  key={t.id || i}
                  className="border-t hover:bg-gray-50 transition text-sm"
                >
                  <td className="p-3 text-gray-600">
                    {i + 1 + (page - 1) * pageSize}
                  </td>
                  <td className="p-3">{t.bookingRequestId || "--"}</td>
                  <td className="p-3 font-medium text-gray-900">
                    {t.customerName ??
                      (t.customerId ? `#${t.customerId.slice(0, 6)}...` : "--")}
                  </td>
                  <td className="p-3 text-gray-900">
                    {t.helperName ??
                      (t.helperId ? `#${t.helperId.slice(0, 6)}...` : "--")}
                  </td>
                  <td className="p-3 text-green-700 font-semibold">
                    {(Number(t.amount) || 0).toLocaleString()} đ
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
                    {t.createdAt
                      ? new Date(t.createdAt).toLocaleDateString("vi-VN")
                      : "--"}
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
                  colSpan={8}
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
          Biểu đồ doanh thu 7 ngày gần nhất
        </h2>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData}>
              <XAxis dataKey="day" />
              <YAxis />
              <Tooltip />
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
  const colorMap = {
    green: "text-green-600",
    red: "text-red-600",
    blue: "text-blue-600",
    orange: "text-orange-600",
  };

  return (
    <div className="bg-white p-4 rounded-xl shadow text-center">
      <p className="text-gray-500">{label}</p>
      <p className={`text-xl font-bold ${colorMap[color] || "text-gray-600"}`}>
        {(Number(value) || 0).toLocaleString()} đ
      </p>
    </div>
  );
}

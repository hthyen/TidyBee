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
import { DollarSign, CreditCard, TrendingUp, RefreshCw, Loader2 } from "lucide-react";
import toast from "react-hot-toast";

export default function Payments() {
  const [transactions, setTransactions] = useState([]);
  const [users, setUsers] = useState({});
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [pageSize] = useState(5);
  const [totalPages, setTotalPages] = useState(1);

  const token = localStorage.getItem("token");

  // 🔹 Lấy danh sách người dùng
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

  // 🔹 Lấy danh sách giao dịch với phân trang
  const fetchTransactions = async (pageNum = 1) => {
    try {
      setLoading(true);
      const res = await getMyTransactions(token, pageNum, pageSize);
      const { transactions: data = [], totalItems = data.length } = res;
      setTransactions(data);
      setPage(pageNum);
      setTotalPages(Math.ceil(totalItems / pageSize) || 1);
    } catch (err) {
      console.error("❌ Lỗi tải danh sách giao dịch:", err);
      toast.error("Không thể tải danh sách giao dịch!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers().then(() => fetchTransactions(1));
  }, []);

  // 🔹 Helper lấy tên khách hàng
  const getCustomerName = (customerId) => {
    return (
      users[String(customerId)] || `#${String(customerId)?.slice(0, 6)}...`
    );
  };

  // 🔹 Tính toán thống kê
  const stats = useMemo(
    () => ({
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
    }),
    [transactions]
  );

  // 🔹 Chuẩn hóa dữ liệu biểu đồ
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

  const statCards = [
    {
      label: "Tổng doanh thu",
      value: stats.totalRevenue,
      icon: DollarSign,
      color: "green",
      bgColor: "bg-green-50",
      textColor: "text-green-600",
      iconColor: "text-green-500",
    },
    {
      label: "Phí nền tảng",
      value: stats.totalPlatformFees,
      icon: CreditCard,
      color: "red",
      bgColor: "bg-red-50",
      textColor: "text-red-600",
      iconColor: "text-red-500",
    },
    {
      label: "Thu nhập cộng tác viên",
      value: stats.totalHelperEarnings,
      icon: TrendingUp,
      color: "blue",
      bgColor: "bg-blue-50",
      textColor: "text-blue-600",
      iconColor: "text-blue-500",
    },
    {
      label: "Hoàn tiền",
      value: stats.totalRefunds,
      icon: RefreshCw,
      color: "orange",
      bgColor: "bg-orange-50",
      textColor: "text-orange-600",
      iconColor: "text-orange-500",
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Quản lý Thanh toán
        </h1>
        <p className="text-gray-600">
          Xem và quản lý tất cả các giao dịch thanh toán trong hệ thống
        </p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
        {statCards.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div
              key={index}
              className="bg-white p-6 rounded-xl shadow-soft hover:shadow-medium transition-all duration-200 border border-gray-100"
            >
              <div className="flex items-center justify-between mb-4">
                <div className={`p-3 rounded-lg ${stat.bgColor}`}>
                  <Icon className={`w-6 h-6 ${stat.iconColor}`} />
                </div>
              </div>
              <h3 className="text-sm font-medium text-gray-600 mb-1">
                {stat.label}
              </h3>
              <p className={`text-2xl font-bold ${stat.textColor}`}>
                {stat.value.toLocaleString()} đ
              </p>
            </div>
          );
        })}
      </div>

      {/* Transactions Table */}
      <div className="bg-white rounded-xl shadow-soft border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  #
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Mã đặt
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Khách hàng
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Số tiền
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Trạng thái
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Ngày
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Phương thức
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {loading ? (
                <tr>
                  <td colSpan={7} className="px-4 py-12 text-center">
                    <Loader2 className="w-8 h-8 animate-spin text-primary-600 mx-auto mb-3" />
                    <p className="text-gray-600 font-medium">Đang tải dữ liệu...</p>
                  </td>
                </tr>
              ) : transactions.length ? (
                transactions.map((t, i) => {
                  const statusInfo = getStatusInfo(t.status);
                  return (
                    <tr
                      key={t.id}
                      className="hover:bg-gray-50 transition-colors"
                    >
                      <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                        {i + 1 + (page - 1) * pageSize}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {t.bookingRequestId || "--"}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {getCustomerName(t.customerId)}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm font-semibold text-green-600 flex items-center gap-1">
                        <DollarSign className="w-4 h-4" />
                        {(t.amount || 0).toLocaleString()} đ
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap">
                        <span
                          className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${statusInfo.color}`}
                        >
                          {statusInfo.label}
                        </span>
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(t.createdAt).toLocaleDateString("vi-VN")}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap">
                        <span
                          className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${
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
                  );
                })
              ) : (
                <tr>
                  <td
                    colSpan={7}
                    className="px-4 py-12 text-center text-gray-500"
                  >
                    <CreditCard className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                    <p className="font-medium">Không có dữ liệu giao dịch</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-3">
          <button
            disabled={page <= 1}
            onClick={() => fetchTransactions(page - 1)}
            className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            aria-label="Previous page"
          >
            ← Trước
          </button>
          <span className="px-4 py-2 text-sm text-gray-700 font-medium">
            Trang {page}/{totalPages}
          </span>
          <button
            disabled={page >= totalPages}
            onClick={() => fetchTransactions(page + 1)}
            className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            aria-label="Next page"
          >
            Sau →
          </button>
        </div>
      )}

      {/* Revenue Chart */}
      <div className="bg-white p-6 rounded-xl shadow-soft border border-gray-100">
        <div className="mb-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-1">
            Biểu đồ doanh thu theo ngày
          </h2>
          <p className="text-sm text-gray-600">
            Biểu đồ thể hiện doanh thu trong các ngày gần đây
          </p>
        </div>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData}>
              <XAxis
                dataKey="day"
                stroke="#6b7280"
                fontSize={12}
                tickLine={false}
              />
              <YAxis
                stroke="#6b7280"
                fontSize={12}
                tickLine={false}
              />
              <Tooltip
                contentStyle={{
                  backgroundColor: "white",
                  border: "1px solid #e5e7eb",
                  borderRadius: "8px",
                  boxShadow: "0 4px 6px -1px rgba(0, 0, 0, 0.1)",
                }}
              />
              <Legend />
              <Bar
                dataKey="revenue"
                fill="#22c55e"
                radius={[8, 8, 0, 0]}
              />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}

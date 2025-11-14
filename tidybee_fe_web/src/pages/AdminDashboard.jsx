import React, { useEffect, useState } from "react";
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
import { Calendar, CheckCircle, DollarSign, TrendingUp } from "lucide-react";

export default function AdminDashboard() {
  const [bookingData, setBookingData] = useState(null);
  const [paymentData, setPaymentData] = useState(null);
  const [loading, setLoading] = useState(true);

  const COLORS = ["#22c55e", "#3b82f6", "#f59e0b", "#ef4444"];

  // Hàm format tiền VND
  const formatVND = (value) => {
    if (!value) return "0₫";
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(value);
  };

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (!token) window.location.href = "/";

    async function fetchData() {
      try {
        // Fetch booking statistics
        const resBookings = await fetch(
          "http://3.25.153.5:8080/api/Bookings/admin/statistics",
          { headers: { Authorization: `Bearer ${token}` } }
        );
        const dataBookings = await resBookings.json();
        setBookingData(dataBookings.data);

        // Fetch payment statistics
        const resPayments = await fetch(
          "http://16.176.128.132:8080/api/payments/statistics",
          { headers: { Authorization: `Bearer ${token}` } }
        );
        const dataPayments = await resPayments.json();
        setPaymentData(dataPayments.data);

        setLoading(false);
      } catch (err) {
        console.error("Error fetching data:", err);
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  if (loading) return <p className="text-center mt-10">Loading...</p>;

  // Booking Stats Cards
  const bookingStats = [
    {
      label: "Tổng số đơn đặt chỗ",
      value: bookingData?.overview.totalBookings ?? 0,
      icon: Calendar,
      bgColor: "bg-purple-50",
      textColor: "text-purple-600",
      iconColor: "text-purple-500",
    },
    {
      label: "Đơn đang chờ",
      value: bookingData?.overview.pendingBookings ?? 0,
      icon: Calendar,
      bgColor: "bg-yellow-50",
      textColor: "text-yellow-600",
      iconColor: "text-yellow-500",
    },
    {
      label: "Đơn đã hoàn thành",
      value: bookingData?.overview.completedBookings ?? 0,
      icon: CheckCircle,
      bgColor: "bg-green-50",
      textColor: "text-green-600",
      iconColor: "text-green-500",
    },
    {
      label: "Doanh thu ước tính",
      value: formatVND(bookingData?.revenue.estimatedPipelineValue ?? 0),
      icon: DollarSign,
      bgColor: "bg-emerald-50",
      textColor: "text-emerald-600",
      iconColor: "text-emerald-500",
    },
  ];

  // Payment Stats Cards
  const paymentStats = [
    {
      label: "Tổng doanh thu",
      value: formatVND(paymentData?.totalRevenue ?? 0),
      icon: DollarSign,
      bgColor: "bg-blue-50",
      textColor: "text-blue-600",
      iconColor: "text-blue-500",
    },
    {
      label: "Tổng phí nền tảng",
      value: formatVND(paymentData?.totalPlatformFees ?? 0),
      icon: DollarSign,
      bgColor: "bg-indigo-50",
      textColor: "text-indigo-600",
      iconColor: "text-indigo-500",
    },
    {
      label: "Tổng thu nhập helper",
      value: formatVND(paymentData?.totalHelperEarnings ?? 0),
      icon: DollarSign,
      bgColor: "bg-green-50",
      textColor: "text-green-600",
      iconColor: "text-green-500",
    },
    {
      label: "Tổng giao dịch thành công",
      value: paymentData?.successfulTransactions ?? 0,
      icon: CheckCircle,
      bgColor: "bg-yellow-50",
      textColor: "text-yellow-600",
      iconColor: "text-yellow-500",
    },
  ];

  // Pie chart for booking status
  const orderStatusData = [
    { name: "Completed", value: bookingData?.overview.completedBookings ?? 0 },
    { name: "Active", value: bookingData?.overview.activeBookings ?? 0 },
    { name: "Pending", value: bookingData?.overview.pendingBookings ?? 0 },
    { name: "Canceled", value: bookingData?.overview.cancelledBookings ?? 0 },
  ];

  // Bar chart: revenue by month (booking)
  const revenueData =
    bookingData?.monthlyTrends.map((item) => ({
      day: item.month,
      revenue: item.revenue,
    })) ?? [];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Tổng quan hệ thống
        </h1>
        <p className="text-gray-600">
          Xem tổng quan về hoạt động, thanh toán và hiệu suất của hệ thống
        </p>
      </div>

      {/* Booking Stats Cards */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
        {bookingStats.map((stat, index) => {
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
                <TrendingUp className="w-5 h-5 text-gray-400" />
              </div>
              <h3 className="text-sm font-medium text-gray-600 mb-1">
                {stat.label}
              </h3>
              <p className={`text-2xl font-bold ${stat.textColor}`}>
                {stat.value}
              </p>
            </div>
          );
        })}
      </section>

      {/* Payment Stats Cards */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
        {paymentStats.map((stat, index) => {
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
                <TrendingUp className="w-5 h-5 text-gray-400" />
              </div>
              <h3 className="text-sm font-medium text-gray-600 mb-1">
                {stat.label}
              </h3>
              <p className={`text-2xl font-bold ${stat.textColor}`}>
                {stat.value}
              </p>
            </div>
          );
        })}
      </section>

      {/* Charts */}
      <section className="grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-6">
        {/* Revenue Chart */}
        <div className="bg-white p-6 rounded-xl shadow-soft border border-gray-100">
          <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-1">
              Doanh thu theo tháng
            </h2>
            <p className="text-sm text-gray-600">
              Biểu đồ thể hiện doanh thu theo tháng
            </p>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={revenueData}>
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
                  tickFormatter={(value) => formatVND(value)}
                />
                <Tooltip
                  formatter={(value) => formatVND(value)}
                  contentStyle={{
                    backgroundColor: "white",
                    border: "1px solid #e5e7eb",
                    borderRadius: "8px",
                    boxShadow: "0 4px 6px -1px rgba(0, 0, 0, 0.1)",
                  }}
                />
                <Legend />
                <Bar dataKey="revenue" fill="#22c55e" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Order Status Chart */}
        <div className="bg-white p-6 rounded-xl shadow-soft border border-gray-100">
          <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-1">
              Số đơn theo trạng thái
            </h2>
            <p className="text-sm text-gray-600">
              Phân bổ các đơn hàng theo trạng thái hiện tại
            </p>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={orderStatusData}
                  dataKey="value"
                  nameKey="name"
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  label={(entry) => `${entry.name}: ${entry.value}`}
                >
                  {orderStatusData.map((entry, index) => (
                    <Cell
                      key={`cell-${index}`}
                      fill={COLORS[index % COLORS.length]}
                    />
                  ))}
                </Pie>
                <Tooltip
                  contentStyle={{
                    backgroundColor: "white",
                    border: "1px solid #e5e7eb",
                    borderRadius: "8px",
                    boxShadow: "0 4px 6px -1px rgba(0, 0, 0, 0.1)",
                  }}
                />
                <Legend
                  wrapperStyle={{ paddingTop: "20px" }}
                  iconType="circle"
                />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>
    </div>
  );
}

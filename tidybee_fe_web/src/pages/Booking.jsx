import React, { useEffect, useState } from "react";
import axios from "axios";
import { API } from "../services/api";
import toast from "react-hot-toast";
import {
  Calendar,
  MapPin,
  DollarSign,
  Eye,
  CheckCircle,
  XCircle,
  Clock,
  Settings,
  X,
  Loader2,
} from "lucide-react";

export default function Booking() {
  const [bookings, setBookings] = useState([]);
  const [selectedBooking, setSelectedBooking] = useState(null);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Lấy danh sách Booking từ API
  const fetchBookings = async (pageNum = 1) => {
    try {
      setLoading(true);
      const token = localStorage.getItem("token");
      const res = await axios.get(`${API.BOOKING}/Bookings/admin/all`, {
        headers: { Authorization: `Bearer ${token}` },
        params: { page: pageNum, size: 10 },
      });

      const data = res.data?.data;
      setBookings(data?.bookings || []);
      setTotalPages(data?.totalPages || 1);
      setPage(data?.page || 1);
    } catch (err) {
      console.error("❌ Lỗi tải bookings:", err);
      toast.error("Không thể tải danh sách booking!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, []);

  // Cập nhật trạng thái Booking
  const handleUpdateStatus = async (bookingId, newStatus) => {
    const token = localStorage.getItem("token");
    const booking = bookings.find((b) => b.id === bookingId);

    const payload = {
      newStatus,
      adminNotes: "[Admin] Cập nhật trạng thái",
    };

    // Chỉ gửi finalPrice khi hoàn thành
    if (newStatus === 3) {
      payload.finalPrice = booking?.estimatedPrice || 0;
    }

    try {
      await axios.patch(
        `${API.BOOKING}/Bookings/admin/${bookingId}/status`,
        payload,
        { headers: { Authorization: `Bearer ${token}` } }
      );

      toast.success("✅ Cập nhật trạng thái thành công!");
      fetchBookings(page);
      if (selectedBooking?.id === bookingId) {
        setSelectedBooking({ ...selectedBooking, status: newStatus });
      }
    } catch (err) {
      console.error(
        "❌ Lỗi cập nhật trạng thái:",
        err.response?.data || err.message
      );
      toast.error("Không thể cập nhật trạng thái!");
    }
  };

  // Xem chi tiết Booking
  const handleView = (booking) => {
    setSelectedBooking(booking);
  };

  // Hàm hiển thị trạng thái
  const getStatusInfo = (status) => {
    switch (status) {
      case 0:
        return {
          label: "Chưa xác định",
          color: "bg-gray-100 text-gray-700",
          icon: Settings,
        };
      case 1:
        return {
          label: "Chờ xử lý",
          color: "bg-yellow-100 text-yellow-700",
          icon: Clock,
        };
      case 2:
        return {
          label: "Đang thực hiện",
          color: "bg-blue-100 text-blue-700",
          icon: Calendar,
        };
      case 3:
        return {
          label: "Đã hoàn thành",
          color: "bg-green-100 text-green-700",
          icon: CheckCircle,
        };
      case 4:
        return {
          label: "Đã huỷ",
          color: "bg-red-100 text-red-700",
          icon: XCircle,
        };
      default:
        return {
          label: "Không xác định",
          color: "bg-gray-100 text-gray-700",
          icon: Settings,
        };
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Quản lý Booking
        </h1>
        <p className="text-gray-600">
          Xem và quản lý tất cả các đơn booking trong hệ thống
        </p>
      </div>

      {/* Loading State */}
      {loading ? (
        <div className="flex flex-col items-center justify-center py-20">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600 mb-4" />
          <p className="text-gray-600 font-medium">
            Đang tải danh sách booking...
          </p>
        </div>
      ) : (
        <>
          {/* Table */}
          <div className="bg-white rounded-xl shadow-soft border border-gray-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      #
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Dịch vụ
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Địa chỉ
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Giá dự kiến
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Trạng thái
                    </th>
                    <th className="px-4 py-4 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Hành động
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {bookings.length > 0 ? (
                    bookings.map((b, index) => {
                      const statusInfo = getStatusInfo(b.status);
                      const StatusIcon = statusInfo.icon;
                      return (
                        <tr
                          key={b.id}
                          className="hover:bg-gray-50 transition-colors cursor-pointer"
                          onClick={() => handleView(b)}
                        >
                          <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                            {index + 1 + (page - 1) * 10}
                          </td>
                          <td className="px-4 py-4 text-sm font-medium text-gray-900">
                            {b.title || "Không có tiêu đề"}
                          </td>
                          <td className="px-4 py-4 text-sm text-gray-600">
                            <div className="flex items-center gap-2">
                              <MapPin className="w-4 h-4 text-gray-400 flex-shrink-0" />
                              <span className="truncate max-w-xs">
                                {b.serviceLocation?.address || "—"}
                              </span>
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap text-sm font-semibold text-green-600">
                            <div className="flex items-center gap-1">
                              <DollarSign className="w-4 h-4" />
                              {b.estimatedPrice?.toLocaleString() || 0} đ
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <span
                              className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${statusInfo.color}`}
                            >
                              <StatusIcon className="w-3.5 h-3.5" />
                              {statusInfo.label}
                            </span>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap text-center text-sm">
                            <div className="flex items-center justify-center gap-2">
                              {b.status !== 3 && b.status !== 4 && (
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleUpdateStatus(b.id, 3);
                                  }}
                                  className="px-3 py-1.5 bg-primary-600 text-white text-xs font-medium rounded-lg hover:bg-primary-700 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                                  aria-label="Complete booking"
                                >
                                  Hoàn thành
                                </button>
                              )}
                            </div>
                          </td>
                        </tr>
                      );
                    })
                  ) : (
                    <tr>
                      <td
                        colSpan="6"
                        className="px-4 py-12 text-center text-gray-500"
                      >
                        <Calendar className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                        <p className="font-medium">Không có booking nào.</p>
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
                onClick={() => fetchBookings(page - 1)}
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
                onClick={() => fetchBookings(page + 1)}
                className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                aria-label="Next page"
              >
                Sau →
              </button>
            </div>
          )}
        </>
      )}

      {/* Modal chi tiết */}
      {selectedBooking && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedBooking(null)}
          role="dialog"
          aria-modal="true"
          aria-labelledby="modal-title"
        >
          <div
            className="bg-white rounded-xl shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
              <h2 id="modal-title" className="text-2xl font-bold text-gray-900">
                Chi tiết Booking
              </h2>
              <button
                onClick={() => setSelectedBooking(null)}
                className="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500"
                aria-label="Close modal"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Body */}
            <div className="px-6 py-6 space-y-6">
              {/* Basic Information */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    ID
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.id}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Dịch vụ
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.title || "Không có"}
                  </p>
                </div>
                <div className="md:col-span-2">
                  <label className="text-sm font-medium text-gray-500">
                    Mô tả
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.description || "Không có"}
                  </p>
                </div>
                <div className="md:col-span-2">
                  <label className="text-sm font-medium text-gray-500">
                    Địa chỉ
                  </label>
                  <p className="mt-1 text-sm text-gray-900 flex items-center gap-2">
                    <MapPin className="w-4 h-4 text-gray-400" />
                    {selectedBooking.serviceLocation?.address || "Không có"}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Loại dịch vụ
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.serviceType || "—"}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Trạng thái
                  </label>
                  <div className="mt-1">
                    {(() => {
                      const statusInfo = getStatusInfo(selectedBooking.status);
                      const StatusIcon = statusInfo.icon;
                      return (
                        <span
                          className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${statusInfo.color}`}
                        >
                          <StatusIcon className="w-3.5 h-3.5" />
                          {statusInfo.label}
                        </span>
                      );
                    })()}
                  </div>
                </div>
              </div>

              {/* Pricing */}
              <div className="border-t border-gray-200 pt-4">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">
                  Thông tin giá
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium text-gray-500">
                      Giá dự kiến
                    </label>
                    <p className="mt-1 text-sm font-semibold text-green-600 flex items-center gap-1">
                      <DollarSign className="w-4 h-4" />
                      {selectedBooking.estimatedPrice?.toLocaleString() || 0} đ
                    </p>
                  </div>
                  {selectedBooking.status === 3 && (
                    <div>
                      <label className="text-sm font-medium text-gray-500">
                        Giá thực tế
                      </label>
                      <p className="mt-1 text-sm font-semibold text-green-600 flex items-center gap-1">
                        <DollarSign className="w-4 h-4" />
                        {selectedBooking.finalPrice?.toLocaleString() || 0} đ
                      </p>
                    </div>
                  )}
                </div>
              </div>

              {/* Time Information */}
              <div className="border-t border-gray-200 pt-4">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">
                  Thông tin thời gian
                </h3>
                <div className="space-y-3">
                  <div>
                    <label className="text-sm font-medium text-gray-500">
                      Thời gian dự kiến
                    </label>
                    <p className="mt-1 text-sm text-gray-900 flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-gray-400" />
                      {new Date(
                        selectedBooking.scheduledStartTime
                      ).toLocaleString()}{" "}
                      -{" "}
                      {new Date(
                        selectedBooking.scheduledEndTime
                      ).toLocaleString()}
                    </p>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-gray-500">
                      Thời gian thực tế
                    </label>
                    <p className="mt-1 text-sm text-gray-900 flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-gray-400" />
                      {selectedBooking.actualStartTime
                        ? new Date(
                            selectedBooking.actualStartTime
                          ).toLocaleString()
                        : "Chưa bắt đầu"}{" "}
                      -{" "}
                      {selectedBooking.actualEndTime
                        ? new Date(
                            selectedBooking.actualEndTime
                          ).toLocaleString()
                        : "Chưa kết thúc"}
                    </p>
                  </div>
                </div>
              </div>

              {/* Additional Information */}
              <div className="border-t border-gray-200 pt-4 space-y-3">
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Ghi chú KH
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.customerNotes || "Không có"}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Người thực hiện
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.helperInfo?.name ||
                      selectedBooking.helperId ||
                      "Chưa có"}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">
                    Ghi chú helper
                  </label>
                  <p className="mt-1 text-sm text-gray-900">
                    {selectedBooking.helperNotes || "Không có"}
                  </p>
                </div>
                {selectedBooking.isRecurring && (
                  <div>
                    <label className="text-sm font-medium text-gray-500">
                      Dịch vụ định kỳ
                    </label>
                    <p className="mt-1 text-sm text-gray-900">
                      {selectedBooking.recurringPattern} đến{" "}
                      {new Date(
                        selectedBooking.recurringEndDate
                      ).toLocaleDateString()}
                    </p>
                  </div>
                )}
              </div>

              {/* Cancellation Info */}
              {selectedBooking.status === 4 && (
                <div className="border-t border-red-200 bg-red-50 rounded-lg p-4">
                  <h3 className="text-lg font-semibold text-red-900 mb-3">
                    Thông tin huỷ
                  </h3>
                  <div className="space-y-2">
                    <div>
                      <label className="text-sm font-medium text-red-700">
                        Đã huỷ lúc
                      </label>
                      <p className="mt-1 text-sm text-red-900">
                        {selectedBooking.cancelledAt
                          ? new Date(
                              selectedBooking.cancelledAt
                            ).toLocaleString()
                          : "Không rõ"}
                      </p>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-red-700">
                        Huỷ bởi
                      </label>
                      <p className="mt-1 text-sm text-red-900">
                        {selectedBooking.cancelledBy || "Không rõ"}
                      </p>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-red-700">
                        Lý do huỷ
                      </label>
                      <p className="mt-1 text-sm text-red-900">
                        {selectedBooking.cancellationReason || "Không có"}
                      </p>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-200 px-6 py-4 flex justify-end gap-3">
              <button
                onClick={() => setSelectedBooking(null)}
                className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
              >
                Đóng
              </button>
              {selectedBooking.status !== 3 && selectedBooking.status !== 4 && (
                <button
                  onClick={() => {
                    handleUpdateStatus(selectedBooking.id, 4);
                    setSelectedBooking(null);
                  }}
                  className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
                >
                  Huỷ Booking
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

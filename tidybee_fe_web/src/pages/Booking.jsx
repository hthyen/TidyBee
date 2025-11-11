import React, { useEffect, useState } from "react";
import axios from "axios";
import { API } from "../services/api";
import toast from "react-hot-toast";

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
    const finalPrice =
      newStatus === 3 ? booking?.estimatedPrice || 0 : booking?.finalPrice || 0;

    try {
      await axios.patch(
        `${API.BOOKING}/Bookings/admin/${bookingId}/status`, // ✔ Sửa URL
        {
          newStatus,
          adminNotes: "[Admin] Cập nhật trạng thái",
          finalPrice,
        },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
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
  const renderStatus = (status) => {
    switch (status) {
      case 0:
        return "⚙️ Chưa xác định";
      case 1:
        return "⏳ Chờ xử lý";
      case 2:
        return "🚀 Đang thực hiện";
      case 3:
        return "✅ Đã hoàn thành";
      case 4:
        return "❌ Đã huỷ";
      default:
        return "⚙️ Không xác định";
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">
        📋 Quản lý Booking
      </h1>

      {loading ? (
        <div className="flex flex-col items-center justify-center py-20 text-gray-500">
          <p className="italic text-lg">⏳ Đang tải danh sách booking...</p>
        </div>
      ) : (
        <>
          <div className="bg-white shadow-md rounded-lg overflow-hidden">
            <table className="min-w-full border-collapse">
              <thead className="bg-green-100 text-gray-700">
                <tr>
                  <th className="p-3 text-left">#</th>
                  <th className="p-3 text-left">Dịch vụ</th>
                  <th className="p-3 text-left">Địa chỉ</th>
                  <th className="p-3 text-left">Giá dự kiến</th>
                  <th className="p-3 text-left">Trạng thái</th>
                  <th className="p-3 text-center">Hành động</th>
                </tr>
              </thead>
              <tbody>
                {bookings.length > 0 ? (
                  bookings.map((b, index) => (
                    <tr
                      key={b.id}
                      className="border-t hover:bg-gray-50 cursor-pointer"
                      onClick={() => handleView(b)}
                    >
                      <td className="p-3">{index + 1 + (page - 1) * 10}</td>
                      <td className="p-3">{b.title || "Không có tiêu đề"}</td>
                      <td className="p-3">
                        {b.serviceLocation?.address || "—"}
                      </td>
                      <td className="p-3">
                        {b.estimatedPrice?.toLocaleString()} đ
                      </td>
                      <td className="p-3">{renderStatus(b.status)}</td>
                      <td className="p-3 text-center">
                        {b.status !== 3 && b.status !== 4 && (
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleUpdateStatus(b.id, 3);
                            }}
                            className="px-3 py-1 bg-green-500 text-white rounded hover:bg-green-600"
                          >
                            Hoàn thành
                          </button>
                        )}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td
                      colSpan="6"
                      className="text-center p-4 text-gray-500 italic"
                    >
                      Không có booking nào.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* Phân trang */}
          {totalPages > 1 && (
            <div className="flex justify-center mt-4 gap-3">
              <button
                disabled={page <= 1}
                onClick={() => fetchBookings(page - 1)}
                className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
              >
                ← Trước
              </button>
              <span className="text-gray-700">
                Trang {page}/{totalPages}
              </span>
              <button
                disabled={page >= totalPages}
                onClick={() => fetchBookings(page + 1)}
                className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
              >
                Sau →
              </button>
            </div>
          )}
        </>
      )}

      {/* Modal chi tiết */}
      {selectedBooking && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-[500px] relative">
            <h2 className="text-xl font-bold mb-4">Chi tiết Booking</h2>

            <p>
              <b>ID:</b> {selectedBooking.id}
            </p>
            <p>
              <b>Dịch vụ:</b> {selectedBooking.title}
            </p>
            <p>
              <b>Địa chỉ:</b>{" "}
              {selectedBooking.serviceLocation?.address || "Không có"}
            </p>
            <p>
              <b>Giá dự kiến:</b>{" "}
              {selectedBooking.estimatedPrice?.toLocaleString()} đ
            </p>
            <p>
              <b>Ghi chú KH:</b> {selectedBooking.customerNotes || "Không có"}
            </p>
            <p>
              <b>Trạng thái:</b> {renderStatus(selectedBooking.status)}
            </p>

            <div className="flex justify-end gap-3 mt-5">
              <button
                onClick={() => setSelectedBooking(null)}
                className="px-4 py-2 rounded border hover:bg-gray-100"
              >
                Đóng
              </button>
              {selectedBooking.status !== 3 && selectedBooking.status !== 4 && (
                <button
                  onClick={() => handleUpdateStatus(selectedBooking.id, 4)}
                  className="px-4 py-2 rounded bg-red-500 text-white hover:bg-red-600"
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

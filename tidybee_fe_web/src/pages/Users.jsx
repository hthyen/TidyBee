import React, { useState, useEffect } from "react";
import axios from "axios";
import toast from "react-hot-toast";
import { API } from "../services/api";
import {
  User,
  Mail,
  Phone,
  Calendar,
  Shield,
  Edit,
  Trash2,
  Search,
  X,
  Save,
  Loader2,
  UserCircle,
} from "lucide-react";

export default function Users() {
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({});
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [searchTerm, setSearchTerm] = useState("");

  const roleMap = {
    1: "Customer",
    2: "Helper",
    3: "Admin",
  };

  const roleColors = {
    1: "bg-blue-100 text-blue-700",
    2: "bg-purple-100 text-purple-700",
    3: "bg-red-100 text-red-700",
  };

  const fetchUsers = async (pageNum = 1) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get(
        `${API.USER}/Users?page=${pageNum}&pageSize=10`,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      const usersData = res.data?.data?.users || [];
      const total = res.data?.data?.totalPages || 1;

      setUsers(Array.isArray(usersData) ? usersData : []);
      setTotalPages(total);
      setPage(pageNum);
    } catch (err) {
      console.error(err);
      toast.error("Không thể tải danh sách người dùng!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers(page);
  }, [page]);

  const handleUserClick = async (id) => {
    setDetailLoading(true);
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get(`${API.USER}/Users/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setSelectedUser(res.data?.data);
      setFormData(res.data?.data);
      setEditMode(false);
    } catch (err) {
      console.error(err);
      toast.error("Không thể tải chi tiết user!");
    } finally {
      setDetailLoading(false);
    }
  };

  const handleDeleteUser = async (id) => {
    if (!window.confirm("Bạn có chắc muốn xoá người dùng này?")) return;
    try {
      const token = localStorage.getItem("token");
      await axios.delete(`${API.USER}/Users/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("🗑️ Xoá người dùng thành công!");
      fetchUsers(page);
      setSelectedUser(null);
    } catch (err) {
      console.error(err);
      toast.error("Không thể xoá người dùng!");
    }
  };

  const handleUpdateUser = async () => {
    try {
      const token = localStorage.getItem("token");
      const payload = {
        email: formData.email || selectedUser.email,
        firstName: formData.firstName || "",
        lastName: formData.lastName || "",
        phoneNumber: formData.phoneNumber || "",
        gender: formData.gender || "other",
        role: Number(formData.role) || 1,
        status: Number(formData.status) || 1,
      };
      await axios.put(`${API.USER}/Users/${selectedUser.id}`, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      });
      toast.success("✅ Cập nhật người dùng thành công!");
      setEditMode(false);
      handleUserClick(selectedUser.id);
      fetchUsers(page);
    } catch (err) {
      console.error(err);
      toast.error("❌ Cập nhật thất bại!");
    }
  };

  const filteredUsers = users.filter((u) => {
    const displayName =
      u.fullName || u.name || `${u.firstName || ""} ${u.lastName || ""}`;
    return (
      displayName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (u.email || "").toLowerCase().includes(searchTerm.toLowerCase())
    );
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Quản lý người dùng
        </h1>
        <p className="text-gray-600">
          Xem và quản lý tất cả người dùng trong hệ thống
        </p>
      </div>

      {/* Search */}
      <div className="bg-white p-4 rounded-xl shadow-soft border border-gray-100">
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            placeholder="Tìm kiếm người dùng theo tên hoặc email..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 placeholder-gray-400"
            aria-label="Search users"
          />
        </div>
      </div>

      {/* Loading State */}
      {loading ? (
        <div className="flex flex-col items-center justify-center py-20">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600 mb-4" />
          <p className="text-gray-600 font-medium">Đang tải người dùng...</p>
        </div>
      ) : (
        <>
          {/* Users Table */}
          <div className="bg-white rounded-xl shadow-soft border border-gray-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      ID
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Họ & Tên
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Email
                    </th>
                    <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                      Vai trò
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
                  {filteredUsers.length > 0 ? (
                    filteredUsers.map((user) => {
                      const displayName =
                        user.fullName ||
                        user.name ||
                        `${user.firstName || ""} ${user.lastName || ""}`;
                      return (
                        <tr
                          key={user.id}
                          className="hover:bg-gray-50 transition-colors cursor-pointer"
                          onClick={() => handleUserClick(user.id)}
                        >
                          <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                            {user.id}
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            <div className="flex items-center gap-2">
                              <UserCircle className="w-5 h-5 text-gray-400" />
                              {displayName || "—"}
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-600">
                            <div className="flex items-center gap-2">
                              <Mail className="w-4 h-4 text-gray-400" />
                              {user.email || "—"}
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <span
                              className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${
                                roleColors[user.role] || "bg-gray-100 text-gray-700"
                              }`}
                            >
                              <Shield className="w-3.5 h-3.5" />
                              {roleMap[user.role] || "—"}
                            </span>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <span
                              className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${
                                user.status === 1
                                  ? "bg-green-100 text-green-700"
                                  : "bg-gray-100 text-gray-700"
                              }`}
                            >
                              {user.status === 1 ? "Hoạt động" : "Không hoạt động"}
                            </span>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap text-center text-sm">
                            <div className="flex items-center justify-center gap-2">
                              <button
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleUserClick(user.id);
                                }}
                                className="p-2 text-gray-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500"
                                aria-label="View user"
                              >
                                <User className="w-4 h-4" />
                              </button>
                              <button
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleDeleteUser(user.id);
                                }}
                                className="p-2 text-gray-600 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-red-500"
                                aria-label="Delete user"
                              >
                                <Trash2 className="w-4 h-4" />
                              </button>
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
                        <User className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                        <p className="font-medium">Không có người dùng nào.</p>
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
                onClick={() => fetchUsers(page - 1)}
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
                onClick={() => fetchUsers(page + 1)}
                className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                aria-label="Next page"
              >
                Sau →
              </button>
            </div>
          )}
        </>
      )}

      {/* User Detail Modal */}
      {selectedUser && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => {
            setSelectedUser(null);
            setEditMode(false);
          }}
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
              <h2
                id="modal-title"
                className="text-2xl font-bold text-gray-900"
              >
                {editMode ? "Chỉnh sửa người dùng" : "Chi tiết người dùng"}
              </h2>
              <button
                onClick={() => {
                  setSelectedUser(null);
                  setEditMode(false);
                }}
                className="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500"
                aria-label="Close modal"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Body */}
            <div className="px-6 py-6">
              {detailLoading ? (
                <div className="flex items-center justify-center py-12">
                  <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
                </div>
              ) : !editMode ? (
                <div className="space-y-6">
                  {/* User Avatar */}
                  <div className="flex items-center gap-4 pb-6 border-b border-gray-200">
                    <div className="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center">
                      <UserCircle className="w-12 h-12 text-primary-600" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold text-gray-900">
                        {selectedUser.firstName} {selectedUser.lastName}
                      </h3>
                      <p className="text-gray-600">{selectedUser.email}</p>
                    </div>
                  </div>

                  {/* User Information */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="text-sm font-medium text-gray-500 flex items-center gap-2 mb-2">
                        <Mail className="w-4 h-4" />
                        Email
                      </label>
                      <p className="text-sm text-gray-900">{selectedUser.email}</p>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-gray-500 flex items-center gap-2 mb-2">
                        <Phone className="w-4 h-4" />
                        Số điện thoại
                      </label>
                      <p className="text-sm text-gray-900">
                        {selectedUser.phoneNumber || "—"}
                      </p>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-gray-500 flex items-center gap-2 mb-2">
                        <Calendar className="w-4 h-4" />
                        Giới tính
                      </label>
                      <p className="text-sm text-gray-900">
                        {selectedUser.gender || "—"}
                      </p>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-gray-500 flex items-center gap-2 mb-2">
                        <Shield className="w-4 h-4" />
                        Vai trò
                      </label>
                      <span
                        className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${
                          roleColors[selectedUser.role] || "bg-gray-100 text-gray-700"
                        }`}
                      >
                        <Shield className="w-3.5 h-3.5" />
                        {roleMap[selectedUser.role] || "—"}
                      </span>
                    </div>
                    <div>
                      <label className="text-sm font-medium text-gray-500 mb-2">
                        Trạng thái
                      </label>
                      <span
                        className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${
                          selectedUser.status === 1
                            ? "bg-green-100 text-green-700"
                            : "bg-gray-100 text-gray-700"
                        }`}
                      >
                        {selectedUser.status === 1 ? "Hoạt động" : "Không hoạt động"}
                      </span>
                    </div>
                  </div>
                </div>
              ) : (
                <form className="space-y-6">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Họ
                      </label>
                      <input
                        type="text"
                        value={formData.firstName || ""}
                        onChange={(e) =>
                          setFormData({ ...formData, firstName: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900"
                        placeholder="Nhập họ"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Tên
                      </label>
                      <input
                        type="text"
                        value={formData.lastName || ""}
                        onChange={(e) =>
                          setFormData({ ...formData, lastName: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900"
                        placeholder="Nhập tên"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Số điện thoại
                      </label>
                      <input
                        type="text"
                        value={formData.phoneNumber || ""}
                        onChange={(e) =>
                          setFormData({ ...formData, phoneNumber: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900"
                        placeholder="Nhập số điện thoại"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Giới tính
                      </label>
                      <select
                        value={formData.gender || "other"}
                        onChange={(e) =>
                          setFormData({ ...formData, gender: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 bg-white"
                      >
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Vai trò
                      </label>
                      <select
                        value={formData.role || 1}
                        onChange={(e) =>
                          setFormData({ ...formData, role: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 bg-white"
                      >
                        <option value="1">Customer</option>
                        <option value="2">Helper</option>
                        <option value="3">Admin</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Trạng thái
                      </label>
                      <select
                        value={formData.status || 1}
                        onChange={(e) =>
                          setFormData({ ...formData, status: e.target.value })
                        }
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 bg-white"
                      >
                        <option value="1">Hoạt động</option>
                        <option value="0">Không hoạt động</option>
                      </select>
                    </div>
                  </div>
                </form>
              )}
            </div>

            {/* Modal Footer */}
            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-200 px-6 py-4 flex justify-end gap-3">
              {!editMode ? (
                <>
                  <button
                    onClick={() => setEditMode(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                  >
                    <Edit className="w-4 h-4" />
                    Chỉnh sửa
                  </button>
                  <button
                    onClick={() => {
                      setSelectedUser(null);
                      setEditMode(false);
                    }}
                    className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                  >
                    Đóng
                  </button>
                </>
              ) : (
                <>
                  <button
                    onClick={handleUpdateUser}
                    className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                  >
                    <Save className="w-4 h-4" />
                    Lưu
                  </button>
                  <button
                    onClick={() => {
                      setEditMode(false);
                      setFormData(selectedUser);
                    }}
                    className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                  >
                    Huỷ
                  </button>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

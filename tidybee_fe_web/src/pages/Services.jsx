// src/pages/Services.jsx
import React, { useState } from "react";

export default function Services() {
  const [services, setServices] = useState([
    { id: "s001", name: "Lau nhà", price: 100, description: "Lau sàn, hút bụi" },
    { id: "s002", name: "Dọn bếp", price: 80, description: "Vệ sinh bếp, hút bụi" },
  ]);

  const [showModal, setShowModal] = useState(false);
  const [editService, setEditService] = useState(null);
  const [form, setForm] = useState({ name: "", price: "", description: "" });

  const openAddModal = () => {
    setForm({ name: "", price: "", description: "" });
    setEditService(null);
    setShowModal(true);
  };

  const openEditModal = (service) => {
    setForm({ name: service.name, price: service.price, description: service.description });
    setEditService(service);
    setShowModal(true);
  };

  const handleSave = () => {
    if (!form.name || !form.price) return;

    if (editService) {
      // Edit existing service
      setServices(
        services.map((s) =>
          s.id === editService.id ? { ...s, ...form } : s
        )
      );
    } else {
      // Add new service
      const newId = `s${(services.length + 1).toString().padStart(3, "0")}`;
      setServices([...services, { id: newId, ...form }]);
    }
    setShowModal(false);
  };

  const handleDelete = (id) => {
    if (window.confirm("Bạn có chắc chắn muốn xóa dịch vụ này?")) {
      setServices(services.filter((s) => s.id !== id));
    }
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Services Management</h1>
        <button
          onClick={openAddModal}
          className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition"
        >
          + Thêm dịch vụ
        </button>
      </div>

      {/* Services Table */}
      <div className="overflow-x-auto bg-white rounded-lg shadow">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700">
            <tr>
              <th className="p-3 text-left">ID</th>
              <th className="p-3 text-left">Tên dịch vụ</th>
              <th className="p-3 text-left">Giá/giờ</th>
              <th className="p-3 text-left">Mô tả</th>
              <th className="p-3 text-center">Hành động</th>
            </tr>
          </thead>
          <tbody>
            {services.map((s) => (
              <tr key={s.id} className="border-t hover:bg-gray-50 transition">
                <td className="p-3">{s.id}</td>
                <td className="p-3">{s.name}</td>
                <td className="p-3">{s.price}k</td>
                <td className="p-3">{s.description}</td>
                <td className="p-3 text-center flex justify-center gap-2">
                  <button
                    onClick={() => openEditModal(s)}
                    className="text-blue-600 hover:underline"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDelete(s.id)}
                    className="text-red-600 hover:underline"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center">
          <div className="bg-white rounded-lg shadow-lg p-6 w-96">
            <h2 className="text-xl font-bold mb-4">{editService ? "Edit Service" : "Add New Service"}</h2>
            <input
              type="text"
              placeholder="Tên dịch vụ"
              className="w-full border px-3 py-2 rounded mb-3"
              value={form.name}
              onChange={(e) => setForm({ ...form, name: e.target.value })}
            />
            <input
              type="number"
              placeholder="Giá/giờ"
              className="w-full border px-3 py-2 rounded mb-3"
              value={form.price}
              onChange={(e) => setForm({ ...form, price: e.target.value })}
            />
            <textarea
              placeholder="Mô tả"
              className="w-full border px-3 py-2 rounded mb-3"
              value={form.description}
              onChange={(e) => setForm({ ...form, description: e.target.value })}
            />
            <div className="flex justify-end gap-3">
              <button
                onClick={() => setShowModal(false)}
                className="px-4 py-2 rounded border hover:bg-gray-100"
              >
                Hủy
              </button>
              <button
                onClick={handleSave}
                className="px-4 py-2 rounded bg-green-500 text-white hover:bg-green-600"
              >
                Lưu
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

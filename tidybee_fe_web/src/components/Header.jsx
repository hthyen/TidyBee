import React from "react";
import { Bell, LogOut, Search } from "lucide-react";
import { useNavigate } from "react-router-dom";

function Header() {
  const navigate = useNavigate();

  const handleLogout = () => {
    if (window.confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      alert("Bạn đã đăng xuất thành công!");
      navigate("/");
    }
  };

  return (
    <header className="flex justify-between items-center bg-white px-6 py-3 shadow-md sticky top-0 z-40">
      {/* Thanh tìm kiếm */}
      <div className="flex items-center bg-gray-100 px-3 py-2 rounded-xl w-80">
        <Search className="text-gray-500 w-5 h-5 mr-2" />
        <input
          type="text"
          placeholder="Tìm kiếm..."
          className="bg-transparent outline-none w-full text-gray-700"
        />
      </div>

      {/* Khu vực bên phải */}
      <div className="flex items-center gap-6">
        {/* Thông báo */}
        <div className="relative cursor-pointer">
          <Bell className="w-6 h-6 text-gray-600" />
          <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full px-1">
            3
          </span>
        </div>

        {/* Avatar admin */}
        <div className="flex items-center gap-2">
          <img
            src="https://i.pravatar.cc/40"
            alt="Admin Avatar"
            className="w-9 h-9 rounded-full border"
          />
          <span className="font-medium text-gray-700">
            {(() => {
              const userData = localStorage.getItem("user");
              if (!userData) return "Admin";
              try {
                const user = JSON.parse(userData);
                return user.email || "Admin";
              } catch {
                return "Admin";
              }
            })()}
          </span>
        </div>

        {/* Logout */}
        <button
          onClick={handleLogout}
          className="flex items-center gap-1 text-red-600 font-medium hover:text-red-700 transition"
        >
          <LogOut className="w-5 h-5" />
          Đăng xuất
        </button>
      </div>
    </header>
  );
}

export default Header;

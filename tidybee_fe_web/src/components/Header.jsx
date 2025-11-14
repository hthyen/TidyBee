import React from "react";
import { Bell, LogOut, Search, User, Menu, X } from "lucide-react";
import { useNavigate } from "react-router-dom";

function Header({ onMenuClick }) {
  const navigate = useNavigate();

  const handleLogout = () => {
    if (window.confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      alert("Bạn đã đăng xuất thành công!");
      navigate("/");
    }
  };

  const userEmail = (() => {
    const userData = localStorage.getItem("user");
    if (!userData) return "Admin";
    try {
      const user = JSON.parse(userData);
      return user.email || "Admin";
    } catch {
      return "Admin";
    }
  })();

  return (
    <header className="sticky top-0 z-40 bg-white border-b border-gray-200 shadow-sm">
      <div className="flex items-center justify-between px-4 sm:px-6 lg:px-8 h-16">
        {/* Left side - Menu button and Search */}
        <div className="flex items-center gap-4 flex-1">
          {/* Mobile menu button */}
          <button
            onClick={onMenuClick}
            className="lg:hidden p-2 rounded-lg text-gray-600 hover:bg-gray-100 hover:text-gray-900 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            aria-label="Toggle menu"
          >
            <Menu className="w-6 h-6" />
          </button>

          {/* Search bar - Hidden on mobile, visible on tablet+ */}
          {/* <div className="hidden md:flex items-center bg-gray-50 px-4 py-2 rounded-lg w-full max-w-md border border-gray-200 focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500/20 transition-all">
            <Search className="text-gray-400 w-5 h-5 mr-3 flex-shrink-0" aria-hidden="true" />
            <input
              type="text"
              placeholder="Tìm kiếm..."
              className="bg-transparent outline-none w-full text-gray-700 placeholder-gray-400 text-sm"
              aria-label="Search"
            />
          </div> */}
        </div>

        {/* Right side - Notifications, User, Logout */}
        <div className="flex items-center gap-3 sm:gap-4">
          {/* Notifications */}
          <button
            className="relative p-2 rounded-lg text-gray-600 hover:bg-gray-100 hover:text-gray-900 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            aria-label="Notifications"
          >
            <Bell className="w-5 h-5 sm:w-6 sm:h-6" />
            <span className="absolute top-1 right-1 bg-red-500 text-white text-xs font-semibold rounded-full w-5 h-5 flex items-center justify-center">
              3
            </span>
          </button>

          {/* User info - Hidden on mobile, visible on tablet+ */}
          <div className="hidden sm:flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-50 transition-colors">
            <div className="w-8 h-8 sm:w-9 sm:h-9 flex items-center justify-center rounded-full bg-gray-200 border-2 border-gray-300">
              <User className="w-5 h-5 text-gray-600" />
            </div>
            <span className="font-medium text-gray-700 text-sm sm:text-base truncate max-w-[120px] sm:max-w-none">
              {userEmail}
            </span>
          </div>

          {/* Logout button */}
          <button
            onClick={handleLogout}
            className="flex items-center gap-2 px-3 py-2 text-red-600 font-medium hover:bg-red-50 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 text-sm sm:text-base"
            aria-label="Logout"
          >
            <LogOut className="w-4 h-4 sm:w-5 sm:h-5" />
            <span className="hidden sm:inline">Đăng xuất</span>
          </button>
        </div>
      </div>
    </header>
  );
}

export default Header;

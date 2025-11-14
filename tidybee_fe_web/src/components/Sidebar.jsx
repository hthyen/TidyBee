import { Link, useLocation } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  Calendar,
  CreditCard,
  Star,
  X,
} from "lucide-react";
import logo from "../assets/logo.png";

export default function Sidebar({ isOpen, onClose }) {
  const location = useLocation();

  const navItems = [
    { path: "/admin", label: "Dashboard", icon: LayoutDashboard },
    { path: "/admin/users", label: "Users", icon: Users },
    { path: "/admin/booking", label: "Booking", icon: Calendar },
    { path: "/admin/payments", label: "Payments", icon: CreditCard },
    // { path: "/admin/reviews", label: "Reviews", icon: Star },
  ];

  const isActive = (path) => {
    if (path === "/admin") {
      return location.pathname === "/admin";
    }
    return location.pathname.startsWith(path);
  };

  return (
    <>
      {/* Sidebar */}
      <aside
        className={`fixed inset-y-0 left-0 z-40 w-64 bg-white shadow-xl transform transition-transform duration-300 ease-in-out ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        } lg:translate-x-0`}
      >
        <div className="flex flex-col h-full">
          {/* Logo and close button */}
          <div className="flex items-center justify-between p-4 border-b border-gray-200 lg:justify-center">
            <div className="flex items-center justify-center flex-1">
              <div className="bg-white p-2 rounded-xl shadow-soft flex items-center justify-center w-24 h-24 sm:w-28 sm:h-28">
                <img
                  src={logo}
                  alt="TidyBee Logo"
                  className="w-full h-full object-contain"
                />
              </div>
            </div>
            <button
              onClick={onClose}
              className="lg:hidden p-2 rounded-lg text-gray-500 hover:bg-gray-100 hover:text-gray-900 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500"
              aria-label="Close menu"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
            {navItems.map((item) => {
              const Icon = item.icon;
              const active = isActive(item.path);
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  onClick={onClose}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg font-medium transition-all duration-200 ${
                    active
                      ? "bg-primary-50 text-primary-700 shadow-sm border border-primary-200"
                      : "text-gray-700 hover:bg-gray-50 hover:text-gray-900"
                  }`}
                  aria-current={active ? "page" : undefined}
                >
                  <Icon
                    className={`w-5 h-5 flex-shrink-0 ${
                      active ? "text-primary-600" : "text-gray-500"
                    }`}
                  />
                  <span className="text-sm sm:text-base">{item.label}</span>
                </Link>
              );
            })}
          </nav>

          {/* Footer */}
          <div className="p-4 border-t border-gray-200">
            <p className="text-xs text-gray-500 text-center">
              TidyBee Admin Panel
            </p>
          </div>
        </div>
      </aside>
    </>
  );
}

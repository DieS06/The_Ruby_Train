import React from "react";
import { ApolloProvider } from "@apollo/client";
import apolloClient from "@/apollo/client";
import { SideBar } from "@/bundles/components/SideBar";
import ConfirmationDialog from "../components/Utils/ConfirmationDialog";
import LanguageSwitcher from "../components/Locales/LanguageSwitcher";
import "@/styles/layouts/Dashboard.scss";

interface DashboardLayoutProps extends React.PropsWithChildren {
  userRole: string[];
  activeTab?: "personal" | "course"  | "progress";
  renderTab?: (tab: string) => React.ReactNode;
  tabClassName?: (tab: string) => string;
};
    
const DashboardLayout: React.FC<DashboardLayoutProps> = ({
    userRole,
    activeTab,
    renderTab,
    tabClassName,
    children,
}) => {
    const currentTab = activeTab ?? "default";

  return (
    <ApolloProvider client={apolloClient}>
      <LanguageSwitcher />

      <section className={tabClassName?.(currentTab) ?? "dashboard-layout"}>
        <SideBar userRole={userRole} />
        <main className="dashboard-content">
          <ConfirmationDialog />
          {renderTab ? renderTab(currentTab) : children}
        </main>
      </section>
    </ApolloProvider>
  );
};

export default DashboardLayout;

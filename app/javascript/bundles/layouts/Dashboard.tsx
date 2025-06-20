import React from 'react';
import type { Props } from "../../types/Children.type";
import { SideBar } from '../layouts/SideBar';
import '../../styles/layouts/Dashboard.scss';


const Dashboard = ({ children }: Props) => (
    <div className="dashboard-root">
        <SideBar />
        <main>
            {children}
        </main>
    </div>
);

export default Dashboard;
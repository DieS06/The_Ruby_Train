import React, { useState, useEffect }from 'react';
import { SideBar } from '../components/Profiles/SideBar';
import { Navigate, Route, Routes } from 'react-router-dom';
import Personal from '../layouts/PersonalDashboard';
import Progress from '../layouts/ProgressDashboard';
import { useAuth } from '@/stores/useAuth';
import useAuthGuard from '@/stores/useAuthGuard';

import { toast } from "react-toastify";
import { ProgressDataProps } from '@/types/Progress/ProgressData';
import "../../styles/pages/Profile.scss";


const Profile: React.FC = () => {
    const { isAuthenticated, isAuthChecking } = useAuthGuard();
    const userRoles = useAuth.getState().user?.roleNames || [];
    const [progress, setProgress] = useState<ProgressDataProps | null>(null);

    useEffect(() => {
        if (isAuthenticated) { // Solo si el usuario está autenticado
            console.log("Cargando datos de progreso para la simulación...");
            // Tu lógica real para cargar el progreso iría aquí.
            // Por ejemplo: `fetchProgressData(useAuth.getState().user.id).then(data => setProgress(data));`
            setTimeout(() => {
                setProgress({ overall: "50%", currentLesson: "Ruby Basics" }); // Simulación
            }, 500); 
        } else {
            setProgress(null); // Limpiar el progreso si el usuario no está autenticado
        }
    }, [isAuthenticated]);

    if(isAuthChecking) {
        return (
            <div className="loading-screen">
                Checking authentication...
            </div>
        );
    }

    if(!isAuthenticated) {
        return (
            <Navigate to="/" replace />
        )
    }

    const hasRole = (rolesToCheck: string[]): boolean => {
        return rolesToCheck.some(role => userRoles.includes(role));
    };

    return (
        <section className="profile-page">
            <SideBar userRole={userRoles}/>

            <main className="dashboard-content">
                <Routes> 
                    <Route path="/profiles" element={<Personal/>} />
                    <Route path="/progress" element={<Progress progress={progress} />} />

                    {/* {userRole === 'Administrator' && (
                        <Route path="/admin" element={<AdminDashboard profile={profile} />} />
                    )}
                    { (userRole === 'Mentor' || userRole === 'Administrator') && (
                        <Route path="/groups" element={<GroupManagementDashboard profile={profile} />} />
                    )} */}

                    <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
            </main>
        </section>
    );
}

export default Profile;
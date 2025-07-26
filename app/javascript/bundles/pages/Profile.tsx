import React, { useEffect, useState } from "react";
import Layout from "../layouts/Layout";
import AuthGate from "../components/Wrappers/AuthGate";
import Personal from "../layouts/PersonalDashboard";
import Progress from "../layouts/ProgressDashboard";
import { SideBar } from "../components/Profiles/SideBar";
import { UserProfile } from "@/types/Profile/UserInformation";

import "@/styles/pages/Profile.scss";

interface Props {
  profile: UserProfile;
}

const Profile: React.FC<Props> = ({ profile }) => {
  // if (!profile?.user) return null;

  const [activeTab, setActiveTab] = useState<"personal" | "progress">("personal");

  return (
    <AuthGate>
      <Layout>
        <section className="profile-page">
          <SideBar userRole={profile.user.role} onChange={setActiveTab} />
          <main className="dashboard-content">
            {activeTab === "personal" && <Personal profile={profile} />}
            {/* {activeTab === "progress" && <Progress progress={progress} />} */}
          </main>
        </section>
      </Layout>
    </AuthGate>
  );
};

export default Profile;

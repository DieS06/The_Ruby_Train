import React, { use, useMemo, useState } from "react";
import { Tabs, TabList, Tab, TabPanel } from "react-aria-components"
import type { UserProfile } from "@/types/Profile/UserInformation";
import "../../../../styles/components/Profile/Personal_Information/PersonalInfo.scss";

import FormGeneral from "../Forms/FormGeneral";
import FormPasswordChange from "../Forms/FormPasswordChange";
import FormProfile from "../Forms/FormProfile";

interface Props { profileData: UserProfile }

const STORAGE_KEY = "profile:tabs:selected";

const PersonalInformation: React.FC<Props> = ({ profileData }) => {
  const initial = useMemo(() => {
    const url = new URL(window.location.href);
    const fromUrl = url.searchParams.get("tab");
    const fromLS = localStorage.getItem(STORAGE_KEY);
    return (fromUrl || fromLS || "profile");
  }, []);

  const [selected, setSelected] = useState<string>(initial);

  const handleSelect = (key: React.Key) => {
    const k = String(key);
    setSelected(k);
    localStorage.setItem(STORAGE_KEY, k);
    const url = new URL(window.location.href);
    url.searchParams.set("tab", k);
    window.history.replaceState({}, "", url.toString());
  }

  return (
       <Tabs  className="tabs"
              selectedKey={selected}
              onSelectionChange={handleSelect}
       >
        <TabList className="tab-list">
          <Tab id="general" className="tab">General</Tab>
          <Tab id="profile" className="tab">Profile</Tab>
          <Tab id="password" className="tab">Password</Tab>
        </TabList>

        <TabPanel id="general" className="tab-panel">
          <FormGeneral  user={profileData.user} onSuccess={() => null} />
        </TabPanel>

        <TabPanel id="profile" className="tab-panel">
          <FormProfile profile={profileData} />
        </TabPanel>

        <TabPanel id="password" className="tab-panel">
          <FormPasswordChange />
        </TabPanel>
      </Tabs>
  );
};

export { PersonalInformation };
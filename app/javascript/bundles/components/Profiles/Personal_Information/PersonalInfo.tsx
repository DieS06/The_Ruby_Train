import React, { useEffect, useState} from 'react';
import { Tabs, TabList, Tab, TabPanel } from 'react-aria-components'
import { useAuth } from '../../../../stores/useAuth';
import { Input } from '../../Accesible_Assets/Input';
import '../../../../styles/components/Profile/Personal_Information/PersonalInfo.scss';


const PersonalInformation: React.FC = () => {
  const { user, setUser } = useAuth();
  const [localUser, setLocalUser] = useState(user);

  useEffect(() => {
    if (user) setLocalUser(user);
  }, [user]);


  return (
       <Tabs className="tabs">
        <TabList className="tab-list">
          <Tab id="general" className="tab">General</Tab>
          <Tab id="profile" className="tab">Profile</Tab>
          <Tab id="settings" className="tab">Password</Tab>
        </TabList>

        <TabPanel id="general" className="tab-panel">

        </TabPanel>

        <TabPanel id="profile" className="tab-panel">
          <p>Información extendida del perfil (biografía, redes, ocupación...)</p>
        </TabPanel>

        <TabPanel id="password" className="tab-panel">
          
        </TabPanel>
      </Tabs>
  );
};

export { PersonalInformation };
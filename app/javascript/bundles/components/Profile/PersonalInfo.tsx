import React, { useEffect, useState} from 'react';
import { Tabs, TabList, Tab, TabPanel } from 'react-aria-components'
import { useAuth } from '../../../stores/useAuth';
import { getMyProfile, updateMyProfile  } from '../../../services/Profile/profileService';
import { Input } from '../Accesible_Assets/Input';
import '../../../styles/components/Profile/PersonalInfo.scss';


const PersonalInformation: React.FC = () => {
  const { user, setUser } = useAuth();
  const [localUser, setLocalUser] = useState(user);
  // const [profile, setProfile] = useState<any>(null);

  useEffect(() => {
    if (user) setLocalUser(user);
  }, [user]);

  // useEffect(() => {
  //   getMyProfile().then(setProfile).catch(console.error);
  // }, []);

  // const handleSave = async () => {
  //   try {
  //     if (profile) await updateMyProfile(profile);
  //     // Aquí deberías agregar algo como `updateMyUser(user)` si tenés un endpoint para actualizar el `user` también
  //     alert("Datos guardados correctamente.");
  //   } catch (error) {
  //     console.error(error);
  //     alert("Error al guardar los datos.");
  //   }
  // };

  return (
       <Tabs className="tabs">
        <TabList className="tab-list">
          <Tab id="general" className="tab">General</Tab>
          <Tab id="profile" className="tab">Profile</Tab>
          <Tab id="settings" className="tab">Password</Tab>
        </TabList>

        <TabPanel id="general" className="tab-panel">
          {/* <Input
            name="firstName"
            placeholder="First Name"
            aria-label="First Name"
            value={}
            onChange={(e) => setLocalUser({ ...user, first_name: e.target.value })}
          />     

          <SubmitButton onPress={handleSave}>Guardar cambios</SubmitButton> */}
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
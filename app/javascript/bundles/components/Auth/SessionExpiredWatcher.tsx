import { useEffect, useState } from 'react'
import { useAuth } from '@/stores/useAuth'
import SessionExpiredDialog from '../../components/Auth/SessionExpiredDialog'

export default function SessionExpiredWatcher() {
  const signOut = useAuth((s) => s.signOut)
  const [open, setOpen] = useState(false)

  useEffect(() => {
    const params = new URLSearchParams(window.location.search)
    if (params.get('notice') === 'session_expired') {
      signOut()
      setOpen(true)
      
      params.delete('notice')
      const q = params.toString()
      window.history.replaceState({}, '', `${window.location.pathname}${q ? '?' + q : ''}`)
    }
  }, [signOut])

  return (
    <SessionExpiredDialog open={open} onClose={() => setOpen(false)} />
  )
}

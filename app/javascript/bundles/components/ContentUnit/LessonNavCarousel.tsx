import React, { useState, useEffect } from "react"
import { ChevronLeft, ChevronRight } from "lucide-react"
import Spinner from "../Loading/Spinner";
import "@/styles/components/Content_Unit/LessonNavCarousel.scss"

interface Item { id: string; title: string; slug: string }

interface Props {
  loading: boolean
  items: Item[]
  onNavigate: (slug: string) => void
}

export default function LessonNavCarousel({ loading, items, onNavigate }: Props) {
  const [idx, setIdx] = useState(1)

  useEffect(() => {
    setIdx(items.length === 3 ? 1 : 0)
  }, [items])

  if (loading) return <Spinner size={24} className="py-2" />

  if (items.length === 0) {
    return (
      <nav className="lesson-nav empty">
        <span className="lesson-nav-title">No lessons available</span>
      </nav>
    )
  }

  const show = items[idx]

  return (
    <nav className="lesson-nav">
      <button
        className="nav-button left"
        disabled={idx === 0}
        onClick={() => setIdx(idx - 1)}
      >
        <ChevronLeft size={20} />
      </button>
      <div
        className="lesson-nav-title"
        role="link"
        tabIndex={0}
        onClick={() => onNavigate(show.slug)}
      >
        {show.title}
      </div>

      <button
        className="nav-button right"
        disabled={idx === items.length - 1}
        onClick={() => setIdx(idx + 1)}
      >
        <ChevronRight size={20} />
      </button>
    </nav>
  )
}
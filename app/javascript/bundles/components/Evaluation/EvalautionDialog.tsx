import React, { useEffect, useMemo, useState } from "react"

type AnswerOption = { id: number; option_text: string; is_correct: boolean }
type Question = { id: number; statement: string; question_type: number; points: number; answer_options: AnswerOption[] }
type Evaluation = { id: number; title: string; description: string; time_limit?: number; questions: Question[] }

interface Props {
  open: boolean
  evaluationId: number
  onClose: () => void
  onPassed?: (score: number, passed: boolean) => void
  token?: string
}

export default function EvaluationDialog({ open, evaluationId, onClose, onPassed }: Props) {
  const [loading, setLoading] = useState(false)
  const [evalData, setEvalData] = useState<Evaluation | null>(null)
  const [answers, setAnswers] = useState<Record<number, number[]>>({})
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!open) return
    setLoading(true)
    fetch(`/api/evaluations/${evaluationId}`, { headers: { Accept: "application/json" } })
      .then((r) => (r.ok ? r.json() : Promise.reject(r)))
      .then((json) => {
        setEvalData(json)
        setAnswers({})
      })
      .catch(() => setError("No se pudo cargar la evaluación"))
      .finally(() => setLoading(false))
  }, [open, evaluationId])

  const handlePick = (q: Question, optionId: number) => {
    setAnswers((prev) => {
      const current = prev[q.id] || []
      if (q.question_type === 0 || q.question_type === 2) {
        return { ...prev, [q.id]: [optionId] }
      }
      const exists = current.includes(optionId)
      return { ...prev, [q.id]: exists ? current.filter((id) => id !== optionId) : [...current, optionId] }
    })
  }

  const payload = useMemo(() => {
    const arr = Object.entries(answers).map(([qid, ids]) => ({
      question_id: Number(qid),
      answer_option_ids: ids
    }))
    return { submission: { evaluation_id: evaluationId, answers: arr } }
  }, [answers, evaluationId])

  const onSubmit = () => {
    setSubmitting(true)
    fetch("/api/submissions", {
      method: "POST",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify(payload)
    })
      .then((r) => (r.ok ? r.json() : r.json().then((j) => Promise.reject(j))))
      .then((json) => {
        onPassed?.(json.score, json.passed)
        onClose()
      })
      .catch((j) => setError(j?.error || "No se pudo enviar la evaluación"))
      .finally(() => setSubmitting(false))
  }

  if (!open) return null

  return (
    <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div className="w-full max-w-3xl bg-white rounded-2xl shadow-xl p-4 md:p-6">
        {loading && <div>Cargando…</div>}
        {error && <div className="text-red-600 mb-2">{error}</div>}
        {evalData && (
          <>
            <h2 className="text-xl font-semibold mb-1">{evalData.title}</h2>
            {evalData.description && <p className="text-sm text-gray-600 mb-4">{evalData.description}</p>}

            <div className="space-y-4 max-h-[60vh] overflow-auto pr-2">
              {evalData.questions.map((q, i) => (
                <div key={q.id} className="border rounded-xl p-3">
                  <div className="font-medium">{i + 1}. {q.statement}</div>
                  <div className="mt-2 grid gap-2">
                    {q.answer_options.map((opt) => {
                      const isSingle = q.question_type === 0 || q.question_type === 2
                      const selected = (answers[q.id] || []).includes(opt.id)
                      return (
                        <label key={opt.id} className="flex items-center gap-2 cursor-pointer">
                          <input
                            type={isSingle ? "radio" : "checkbox"}
                            name={`q-${q.id}`}
                            checked={selected}
                            onChange={() => handlePick(q, opt.id)}
                          />
                          <span>{opt.option_text}</span>
                        </label>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-4 flex gap-2 justify-end">
              <button className="px-4 py-2 rounded-xl border" onClick={onClose} disabled={submitting}>Cancelar</button>
              <button className="px-4 py-2 rounded-xl bg-rose-600 text-white shadow" onClick={onSubmit} disabled={submitting}>
                {submitting ? "Enviando…" : "Enviar"}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  )
}

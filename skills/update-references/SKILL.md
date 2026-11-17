---
name: update-references
description: Refreshes docs/REFERENCES.md with new official and well-known articles on AI coding guardrails, harness engineering, agent instructions, testing and review - verifies every source, removes dead links, and proposes rule or skill changes the new material justifies. Use when the user asks to update the references or reading list, or on a monthly schedule.
disable-model-invocation: true
---

# Update references

```
- [ ] 1. Read the current file
- [ ] 2. Check links
- [ ] 3. Search for new material
- [ ] 4. Verify each candidate
- [ ] 5. Edit the file
- [ ] 6. Propose harness changes
- [ ] 7. Commit
```

1. **Read** `docs/REFERENCES.md`. Note its `Last reviewed` date; you're looking for material published since then.
2. **Check links**: run `scripts/check-links.sh`. For each `DEAD` link, find the new location (search the title) or remove the entry.
3. **Search**, official sources first. Run several searches at once:
   - Anthropic: anthropic.com/engineering, code.claude.com/docs (best practices, hooks, skills, memory changes), platform.claude.com skills docs.
   - OpenAI: openai.com/index, Codex docs on AGENTS.md and agent configuration.
   - GitHub (Spec Kit, Copilot agent docs), Google (DORA, Gemini CLI docs), the AGENTS.md standard.
   - Practitioners: martinfowler.com (Böckeler), Simon Willison, Addy Osmani, Kent Beck, Thoughtworks Technology Radar.
   - Topics: harness engineering, agent guardrails, AGENTS.md, spec-driven development, testing AI-written code, mutation testing with agents, AI code review, agent memory/progress files, slopsquatting.
4. **Verify each candidate** by opening it. Keep it only if you read it and it gives a concrete, actionable practice or evidence. Record its real date and author. Mark vendor content as Vendor. If a site blocks fetching, confirm it through reputable coverage and say so in a note, as the OpenAI entry does. Never list something you haven't verified.
5. **Edit the file**: add entries in the existing format and section (title — author — link — date — tier, a one- or two-line takeaway, `Applied:` if this repo uses it). Update entries whose official docs changed. Remove entries that are superseded, and say what replaced them. Set `Last reviewed` to today.
6. **Propose harness changes**: list, for the user, any rule, skill or hook in this repo that the new material contradicts or would improve, with the source. Don't change them in this skill; each becomes its own commit after approval.
7. **Commit** `docs/REFERENCES.md` alone: "Refresh references (YYYY-MM-DD)", with the added and removed entries in the body.

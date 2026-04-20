-- preamble_migration.sql
-- Adds a preamble_md column to pd_modules and populates it for all five modules.
-- Each preamble frames the inquiry-assessment gap through the lens of the
-- parent's home education system, rendered before D1 in the module UI.

-- Step 1: Schema change
ALTER TABLE pd_modules ADD COLUMN IF NOT EXISTS preamble_md TEXT;

-- Step 2: Populate preambles

-- India (india-001)
UPDATE pd_modules
SET preamble_md = 'Every family you will work with learned what "good education" looks like inside a system that answered one question clearly: where does my child rank? In CBSE percentage culture, a 94 means something specific — it means your family can hold its head up. A 78 means something specific too, and the whole neighbourhood knows it. Marks are not just academic measures; they are social proof, read publicly at family gatherings, discussed in WhatsApp groups, used to sort marriage prospects and career trajectories.

Now those families are sitting across from you at a PTM, and you are showing them a portfolio. You are describing growth. You are talking about process. And the parent is quietly thinking: but what is the number?

This module is about the gap between what IB assessment communicates and what CBSE-trained families need to hear. Not because they are wrong to want comparative data — that want is rational and earned — but because if you cannot bridge that gap in conversation, the parent will fill it with anxiety, and you will lose them before you have started.'
WHERE id = 'india-001';

-- KSA (ksa-001)
UPDATE pd_modules
SET preamble_md = 'The families in your classroom made two decisions that look contradictory but are not. They chose an international school because they want globally recognised credentials for their child. And they are watching carefully to see whether that school will erode their child''s cultural and religious identity in the process. This is the selection paradox, and it shapes every interaction you will have.

In the Saudi system, the Tawjihiyya exam sorts students into university tracks and the outcome is legible to the whole family. Assessment means something definitive. When those families encounter IB''s reflective, portfolio-based model, the question is not whether it is pedagogically sound. The question is whether it can be trusted — trusted to produce outcomes, and trusted not to displace Arabic, not to undermine parental authority, not to quietly replace one worldview with another.

This module helps you understand what Saudi families are actually weighing when they ask sharp questions about your curriculum. They are not resisting your teaching. They are stress-testing a bargain they made on behalf of their child, and they need you to prove it holds.'
WHERE id = 'ksa-001';

-- Korea (korea-001)
UPDATE pd_modules
SET preamble_md = 'South Korea has a birth rate of 0.78. Most of the Korean parents you will meet have one child — maybe two. Every financial, emotional, and social resource that family has is concentrated on a single educational outcome. The Suneung national exam is the sorting mechanism, and the hagwon ecosystem that surrounds it means many students study until ten at night from middle school onward. The parent is not a bystander in this system; they are the educational manager, the strategist, the one who chose your school as an alternative lane in a race that never stops.

When that parent calls you in the evening about a grade, or follows up three times after a meeting, or asks a question that feels like an interrogation — that is not hostility. That is the sound of total investment with no margin for error.

This module is about understanding the structure that produces that intensity. Korean parents are not difficult. They are operating inside a zero-sum system where ambiguity is a threat and every adult in the child''s life is accountable. If you understand that, you can work with it. If you don''t, you will personalise it, and the relationship will break down before it begins.'
WHERE id = 'korea-001';

-- China (china-001)
UPDATE pd_modules
SET preamble_md = 'The gaokao is not just an exam. It is the single event around which Chinese educational life organises — preparation starts years before, and the result is understood to decide career trajectory, marriage prospects, and family honour. When a Chinese family chooses an IB school, they have not opted out of that logic. They have made a calculated bet that the international pathway will outperform the gaokao pathway for their specific child in the global economy they expect that child to enter.

That bet is expensive, socially visible, and — under the "double reduction" policy climate where international education now carries political valence — increasingly fraught. So when a parent sits across from you at a conference, nods warmly, and leaves without raising a concern, do not assume the conversation went well. In Chinese communication culture, mianzi (face) means a parent will not challenge you directly. The real assessment of your school is happening in the parent WeChat group after the meeting.

This module teaches you to read what is actually happening in those interactions. The parent who asks for more tests is not rejecting inquiry learning. They are asking for data in the only format their system taught them to trust. Your job is to answer the question they are really asking.'
WHERE id = 'china-001';

-- Woodstock (woodstock-001)
UPDATE pd_modules
SET preamble_md = 'The families coming into your classroom have, until now, navigated systems where the rules were clear. IGCSE gave them percentage grades and subject rankings. AP gave them a 1-to-5 score and college credit they could count. Whatever the limitations of those systems, parents knew how to read the output and how to help their child succeed inside it.

Now the curriculum is changing, and what parents are worried about is not philosophy. They are worried about losing the things that felt solid: the legible grade, the external validation, the credential that a university admissions officer recognises without explanation. They are worried that their child is being asked to be a guinea pig for a transition the school believes in but has not yet proven.

This is a reasonable anxiety, and dismissing it — even gently, even with the best pedagogical intentions — will cost you trust immediately. This module is about understanding what parents are actually afraid of losing in a curriculum transition, and how to have honest conversations that acknowledge the uncertainty without undermining the change. The goal is not to sell the new system. It is to show families, concretely, that their child''s competitive future has not been put at risk.'
WHERE id = 'woodstock-001';

-- Step 3: Verification
SELECT id, LEFT(preamble_md, 60) FROM pd_modules WHERE preamble_md IS NOT NULL;

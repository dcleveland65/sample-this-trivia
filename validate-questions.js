const fs = require('fs');
const src = fs.readFileSync('C:/Users/dcleveland/projects/sample-this-trivia/index.html', 'utf8');
const start = src.indexOf('const QUESTIONS = [');
const end = src.indexOf('\n];', start);
const arr = src.slice(start + 'const QUESTIONS = '.length, end + 2);
const QUESTIONS = eval(arr);

console.log('TOTAL:', QUESTIONS.length);

const byCat = {}, byDiff = {};
QUESTIONS.forEach(q => { byCat[q.cat] = (byCat[q.cat]||0)+1; byDiff[q.diff] = (byDiff[q.diff]||0)+1; });
console.log('BY CAT :', JSON.stringify(byCat));
console.log('BY DIFF:', JSON.stringify(byDiff));

const KNOWN_CATS = ['hip-hop','rock','soul','classical','yacht-rock'];
const KNOWN_DIFF = ['easy','medium','hard'];
const problems = [];
const seen = new Map();

QUESTIONS.forEach((q, i) => {
  const tag = `#${i} ${q.modern && q.modern.title}`;
  ['modern','original','q','hint','fact','opts','ans','diff','cat'].forEach(k => {
    if (q[k] === undefined || q[k] === null || q[k] === '') problems.push(`${tag}: missing "${k}"`);
  });
  if (q.modern && (!q.modern.title || !q.modern.artist || !q.modern.year)) problems.push(`${tag}: incomplete modern{}`);
  if (q.original && (!q.original.title || !q.original.artist || !q.original.year)) problems.push(`${tag}: incomplete original{}`);
  if (!KNOWN_CATS.includes(q.cat)) problems.push(`${tag}: unknown cat "${q.cat}"`);
  if (!KNOWN_DIFF.includes(q.diff)) problems.push(`${tag}: unknown diff "${q.diff}"`);
  if (!Array.isArray(q.opts) || q.opts.length !== 4) problems.push(`${tag}: opts length ${q.opts && q.opts.length}`);
  if (typeof q.ans !== 'number' || q.ans < 0 || q.ans > 3) problems.push(`${tag}: bad ans ${q.ans}`);
  if (Array.isArray(q.opts) && new Set(q.opts).size !== q.opts.length) problems.push(`${tag}: duplicate options`);
  if (typeof q.original?.year === 'number' && typeof q.modern?.year === 'number' && q.original.year > q.modern.year)
    problems.push(`${tag}: original year ${q.original.year} > modern year ${q.modern.year}`);
  const key = (q.modern?.title || '') + '|' + (q.modern?.artist || '');
  if (seen.has(key)) problems.push(`${tag}: DUPLICATE of #${seen.get(key)}`); else seen.set(key, i);
});

// answer-position distribution before shuffle
const dist = [0,0,0,0];
QUESTIONS.forEach(q => { if (typeof q.ans === 'number') dist[q.ans]++; });
console.log('ANS INDEX DIST (pre-shuffle):', dist.join(' / '));

console.log('\nPROBLEMS:', problems.length);
problems.forEach(p => console.log('  -', p));

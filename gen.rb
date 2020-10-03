#!/usr/bin/env ruby

HEADER = %q{
<link rel='stylesheet' href='site.css'>

<a id='logo' href='index.html'><img src='logo.png'></a>
<div id='navbar'>
	<a href='index.html'>Home</a>
	<a href='about.html'>About</a>
	<a href='archives.html'>Archives</a>
</div>
}

def writepage(outname, body)
	File.write outname, "#{HEADER}\n#{body}"
end

sems = Dir.glob 'sem/*/*'
years = sems.map do |sem|
	pages = Dir.children(sem).length
	sem =~ %r{sem/(\d+)/(\w+)}
	[$1, [$2, pages]]
end.reduce({}) do |dict, (year, entry)|
	dict[year] = [] if !dict[year]
	dict[year].push entry
	dict
end.sort_by{ |year, _| -year }.reverse

writepage 'archives.html', %Q[
<title>YJ Archives</title>
<div class='content'>

<h1>Archives</h1>
<p>Here you can read YJ archives!</p>

<ul>
#{years.map{ |year, seasons|
	"<li>#{year}<ul>#{seasons.map{|season, pages| "<li><a href='reader.html?id=#{season.capitalize}#{year}:#{pages}:1'>#{season.capitalize}</a></li>"}.join ''}</ul></li>"
}.join ''}
</ul>

</div>
]

writepage 'index.html', %Q{
<title>The Yellow Journal</title>
<div class='content'>

<h1>The Yellow Journal</h1>

<p>hi mom</p>

<p>interesting and engaging content</p>

<p>could change font!!</p>

<p>i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti</p>

<p>i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti</p>

</div>
}

writepage 'about.html', %Q{
<title>About YJ</title>
<div class='content'>

<h1>About</h1>

<p>I thought about putting putting social media links in a footer but I don't really like footers</p>

<p>hi mom</p>

<p>interesting and engaging content</p>

<p>could change font!!</p>

<p>i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti</p>

<p>i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti i like spaghetti</p>

</div>
}

writepage 'reader.html', %q{
<title>YJ Reader</title>

<h1 id='status' class='center'>nothing to see here</h1>
<a class='left but' href='javascript:void(0)' onclick='prev()'>«</a>
<img id='view' class='center' src='logo.png'>
<a class='right but' href='javascript:void(0)' onclick='next()'>»</a>

<script>
const VIEW = document.querySelector('#view')
const STATUS = document.querySelector('#status')

const id = new URLSearchParams(window.location.search).get('id') || ''
const { season, year, currpage, totalpages } = (id.match(/(?<season>spring|fall)(?<year>\d{4}):(?<totalpages>\d+):(?<currpage>\d+)/i) || { groups: {} }).groups

let curr = +currpage || 1
const end = +totalpages || 1
const move = offset => () => {
	const newpage = Math.max(1, Math.min(end, curr + offset))
	if (newpage === curr && offset !== 0)
		return
	history.replaceState({}, '', `?id=${season}${year}:${totalpages}:${newpage}`)
	display(newpage)
}

const prev = move(-1)
const next = move(+1)

// jumps to a page
const display = pageno => {
	if (!season)
		return
	VIEW.src = `sem/${year}/${season.toLowerCase()}/${pageno}.jpg`
	STATUS.innerText = `${season} ${year} (${pageno}/${end})`
	curr = pageno
}

display(curr)
</script>
}
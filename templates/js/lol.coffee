﻿#dir = (ob) ->
#  out = []
#  for attr of ob
#    out.push attr
#  out.sort()
#  out

loadImage = (name) ->
	img = new Image()
	img.src = "images/" + name + ".png"
	log "failed loading image"  unless img
	img
fixAng = (a) ->
	ang = a
	ang -= 2 * Math.PI  while ang > 2 * Math.PI
	ang += 2 * Math.PI  while ang < 0
	ang
zfill = (n, v, optC) ->
	s = n + ""
	c = optC or "0"
	i = s.length

	while i < v
		s = c + s
		i++
	s

if window.conole is `undefined`
	window.console = {log: (s) -> null}

Object.clone = (obj) ->
	target = {}
	for i of obj
		target[i] = obj[i]  if obj.hasOwnProperty(i)
	target

Object.size = (obj) ->
	size = 0
	key = undefined
	for key of obj
		size++  if obj.hasOwnProperty(key)
	size

Object.keys = (obj) -> (x for x in obj if obj.hasOwnProperty(x))
Object.values = (obj) -> (obj[x] for x in obj if obj.hasOwnProperty(x))
	
load = ->
	parseData = (line) ->
		ndat = line.split(" ")
		key = ndat[1]
		pron = [ndat[2].slice(1)]
		s = ""
		i = 3
		loop
			pron.push ndat[i]
			if ndat[i][ndat[i].length - 1] is "]"
				last = pron.length - 1
				pron[last] = pron[last].slice(0, pron[last].length - 1)
				break
			i++
		meaning = ndat.slice(i + 1).join()
		meaning = meaning.slice(1, meaning.length - 1)
		hanzi2data[key] = [pron, meaning]
	loadData = (dat) ->
		console.log "lol"
		lines = dat.split("
")
		for line of lines
			parseData line
	$.ajax
		url: "cmudict.txt"
		success: loadData
		dataType: "text"

arrayRepeat = (val, n) ->
	r = []
	i = 0

	while i < n
		r.push n
		i++
	r
randItem = (lst) ->
	lst[Math.floor(Math.random() * lst.length)]
nempty = (arr) ->
	c = 0
	i = 0

	while i < arr.length
		c++  if arr[i] isnt ""
		i++
	Nitems - c
shift = (arr) ->
	newarr = []
	i = 0

	while i < arr.length
		newarr.push arr[i]  if arr[i] isnt ""
		i++
	c = newarr.length
	i = 0

	while i < arr.length - newarr.length
		newarr.push ""
		i++
	[newarr, c]
getWords = (n) ->
	i = 0
	lst = []
	for i of showqueue
		console.log showqueue[i]
		if showqueue[i].t is 0
			console.log "zero queue"
			while lst.length <= n and showqueue[i].items.length > 0
				lst.push
					item: showqueue[i].items.pop()
					type: "SQ"

				console.log "getting from showqueue " + lst
	nlst = []
	for i of showqueue
		nlst.push showqueue[i]  unless showqueue[i].items.length is 0
	showqueue = nlst
	i = lst.length

	while i < Math.min(n, words.length - wordid)
		lst.push
			item: words[wordid]
			type: "1st"

		wordid++
		i++
	lst
arrayCut = (arr, x) ->
	arr.slice(0, x).concat arr.slice(x + 1, arr.length)

Nitems = 10
ndone = 0
wordKnowledge = []
showqueue = []
failqueue = []
keyword = []
pinyin = []
history = []
interval = {}
hanzi = arrayRepeat "", Nitems
word2col = {}

updateSlot = (tr) ->
	state = slotmode[tr]
	if state isnt "MATCH"
		s = '<td><button id="tr_'+tr+'" class="changeState">' + hanzi[tr] + "</button></td>"
	else
		s = '<td><button id="tr_' + tr + '" class="matchHanzi">' + hanzi[tr] + "</button></td>"
	if state is "MATCH"
		s+='<td><button id="hanzi_' + tr + '" class="matchPinyin">' + pinyin[tr] + "</button></td>"
		s+='<td><button id="keyword_' + tr + '" class="matchKeyword">' + keyword[tr] + "</button></td>"
	else
		td = 1
	$('#slot_'+tr).html(s)

changeSlot = (tr, state) ->
	slotmode[tr] = state
	updateSlot(tr)	

ziMode = (zi, state) =>
	mode[hanzi[zi]] = state
	# if its visible change the appearance of the slot...
	
words = ['我', '的', '我的', '你', '你的', '我们', '你们', '喜', '喜爱','爱', '喜欢', '欢']
hanzi2data =
	'我':['wo3', 'I'] 
	'的':['de','\'s']
	'我的':['wo3de','my']
	'你':['ni3','you']
	'你的':['ni3de','your']
	'我们':['wo3men','we']
	'你们':['ni3men','you all']
	'喜':['xi3','to enjoy']
	'喜爱':['xi3ai4','to like']
	'爱':['ai4','love']
	'喜欢':['xi3huan1','to like']
	'欢':['huan1','happy']

slotmode = arrayRepeat("", Nitems)
select = undefined
wordid = 0
mode = {}
timer = {}
UpdateTable = true
errorqueue = []
# $(window).load ->
	
nempty = (arr) ->
		Nitems - ((i for i in arr when i isnt "" ).length)
shift = (arr) ->
    newarr = (i for i in arr when i isnt "")
    tail = ("" for x in [1..arr.length-newarr.length])
    [newarr.concat tail, newarr.length]

getWords = (n) ->
	i = 0
	lst = []
	for i of showqueue
		console.log showqueue[i]
		if showqueue[i].t is 0
			console.log "zero queue"
			while lst.length <= n and showqueue[i].items.length > 0
				lst.push
					item: showqueue[i].items.pop()
					type: "SQ"

				console.log "getting from showqueue " + lst
	nlst = []
	for i of showqueue
		nlst.push showqueue[i]  unless showqueue[i].items.length is 0
	showqueue = nlst
	i = lst.length

	while i < Math.min(n, words.length - wordid)
		lst.push
			item: words[wordid]
			type: "1st"

		wordid++
		i++
	lst
arrayCut = (arr, x) ->
	arr.slice(0, x).concat arr.slice(x + 1, arr.length)

gameloop = ->
	console.log "empty" + nempty(hanzi)
	if nempty(hanzi) >= 1
		swapDat = []
		[hanzi, beg] = shift(hanzi)
		newWords = getWords(5)
		console.log "newWords is " + newWords.toSource()

		while i < Math.min(beg + 5, beg + newWords.length)
			# first search the failqueue
			nw = newWords[i - beg]
			hanzi[i] = nw.item
			[keyword[i], pinyin[i]] = hanzi2data[hanzi[i]]
			swapDat.push i  if nw.type is "SQ"			
			mode[hanzi[i]] = "show"
			i++
		
		#ndone++;
		#if(ndone >= 5) done5();

		permute = (lst) ->
			newlst = (x for x in lst)
			for x of lst
				r = Math.floor Math.random()*lst.length        
				[newlst[x],newlst[r]] = [newlst[r], newlst[x]]
			newlst

		keyword = (dat[hanzi[z]][0] for z in permute swapDat)
		pinyin =  (dat[hanzi[z]][1] for z in permute swapDat)
		
		for i of swapDat
		#	pn = parseInt(Math.random() * pswap.length)
		#	kn = parseInt(Math.random() * kswap.length)
		#	k = pswap[pn]
		#	p = kswap[kn]
		#	pswap = arrayCut(pswap, pn)
		#	kswap = arrayCut(kswap, kn)
		#	zi = hanzi[swapDat[i]]
		#	dat = hanzi2data[zi]
		#	keyword[k] = dat[0]
		#	pinyin[p] = dat[1]
		#	console.log "at:" + [kswap, pswap].toSource() + "-" + [pn, kn] + " data=" + dat
			mode[zi] = "TEST"
			changeSlot(swapDat[i], "MATCH")
		drawTab()
	#for key of timer
	#	timer[key] = 0  if timer[key] > 0
	for i of showqueue
		if showqueue[i].t > 0
			showqueue[i].t--
	for i of errorqueue
		if errorqueue[i].t > 0
			errorqueue[i].t--
	timer = (i for i in timer when i.t > 0)

#if(UpdateTable) {
#	drawtab();
#	UpdateTable = false;
#}

# select for matching
done5 = ->
	items = []
	for i of hanzi
		if mode[hanzi[i]] is "done"
			mode[hanzi[i]] = "queu"
			items.push hanzi[i]
			clearRow i
			ndone--
	showqueue.push
		t: Done5Time
		items: items

	console.log showqueue
musteq = (name, a, b) ->
	console.log name + " " + a + "=" + b

drawTab = ->
	write = (_s) ->
		s += _s
	matchFunc = (match, column) ->
		console.log match + " click"
		id = $(this).attr("id").split("_")[1]
		if match is "matchHanzi"
			select["matchHanzi"] = id
			$(this).addClass "hilight"
		else
			matched = column[parseInt(id)]
			zi = hanzi[select["matchHanzi"]]
		dataSelect =
			matchPinyin: 1
			matchKeyword: 0

		console.log [hanzi2data[zi][dataSelect[match]], matched]
		clas = undefined
		if hanzi2data[zi][dataSelect[match]] is matched
			clas = "correct"

		#$(this).addClass('correct');
		# calculate when to show it next
		# AJAX maybe
		else
			clas = "wrong"
			$(this).addClass "wrong"

			# choosing match
			t = 100 # base the T on how much time elapsed
			errorqueue.push
			t: t
			item: zi
			maxt: t
		makeBlink = (cls, obj) ->
			(t) ->
				if t % 4 < 2
					obj.addClass cls
				else
					obj.removeClass cls
		timers.push #error timer
			t: 10
			action: makeBlink(clas, $(this))
		select[match] = matched
	
	s = ""
	write "<table>"
	cols = [hanzi, pinyin, keyword]
	tr = 0

	while tr < hanzi.length
		write "<tr id='slot_" + tr + "'>"
		write "<td>" + mode[hanzi[tr]] + "</td>"
		if slotmode[tr] isnt "MATCH"
			write '<td><button id="tr_'+tr+'" class="changeState">' + hanzi[tr] + "</button></td>"
		else
			write '<td><button id="tr_' + tr + '" class="matchHanzi">' + hanzi[tr] + "</button></td>"
		if slotmode[tr] is "MATCH"
			write '<td><button id="hanzi_' + tr + '" class="matchPinyin">' + pinyin[tr] + "</button></td>"
			write '<td><button id="keyword_' + tr + '" class="matchKeyword">' + keyword[tr] + "</button></td>"
		else
			td = 1

			while td < 3
				write "<td>" + cols[td][tr] + "</td>"
				td++
		write "</tr>"
		tr++
	write "</table>"
	$("#game").html s
	matches = [["matchPinyin", pinyin], ["matchKeyword", keyword], ["matchHanzi", hanzi]]
	for i of matches
		$("." + matches[i][0]).click (-> matchFunc(matches[i][0], matches[i][1]))
	$("button.changeState").click ->
		id = $(this).attr("id").split("_")
		console.log "changeState" + id
		
		#if(mode[hanzi[id[1]]] !== 'done')
 
		mode[hanzi[id[1]]] = "done"
		ndone++
		done5()  if ndone is 5
		console.log "ndone is " + ndone
		drawTab()

clearRow = (i) ->
	hanzi[i] = ""
	pinyin[i] = ""
	keyword[i] = ""
errlog = (s) ->
	LOG += s + "\n"
Done5Time = 2
select = {}
timers = []
LOG = ""


test1 = ->
	words = ['我', '的', '我的', '你', '你的', '我们', '你们', '喜', '喜爱','爱', '喜欢', '欢']
	hanzi2data =
		'我':['wo3', 'I'] 
		'的':['de','\'s']
		'我的':['wo3de','my']
		'你':['ni3','you']
		'你的':['ni3de','your']
		'我们':['wo3men','we']
		'你们':['ni3men','you all']
		'喜':['xi3','to enjoy']
		'喜爱':['xi3ai4','to like']
		'爱':['ai4','love']
		'喜欢':['xi3huan1','to like']
		'欢':['huan1','happy']
	gameloop()
	
	drawTab()
		
		
$(document).ready ->
	test1()
	#gameloop()

	#while i < hanzi.length
	#	mode[hanzi[i]] = "done"
	#	ndone++
	#	i++
	
	#done5()
	#drawTab()
	#gameloop()
	#gameloop()
	#gameloop()
import random
def getMeaning(word):
	inp = open("words.csv","r")
	for line in inp:
		s = line.strip().split(',')
		if word in s[1]:
			word ={}
			return s[2:]

#Return one word have not appeared
def generateWord(subject, id):
	inp = open("words.csv","r")
	res = []
	for line in inp:
		s = line.strip().split(',')
		if s[0] == subject:
			word ={}
			if appeared(s[1],id) == 1:
				continue
			word['word'] = s[1]
			word['type'] = s[2]
			word ['meaning'] = s[3] 
			res.append(word)
	inp.close()
	if len(res) == 0:
		return -1
	i = random.randint(0,len(res)-1)
	writeword(res[i],id)
	return res[i]

#User da co hay chua
def isuser(id):
	inp = open("user.txt","r")
	res = []
	for line in inp:
		if line.strip().split(',')[0] == id:
			inp.close()
			return 1
	inp.close()
	with open("user.txt", "a") as myfile:
		myfile.write(id)

	return 0

#Xem tu da xuat hien hay chua
def appeared (word,id):
	inp = open("user.txt","r")
	res = []
	for line in inp:
		if line.strip().split(',')[0] == id:
			if word in line:
				inp.close()
				return 1
	inp.close()
	return 0

#Viet 1 tu vo trong database
def writeword(word, id):
	inp = open("user.txt","r")
	res = inp.readlines()
	inp.close()
	
	for a in range(len(res)):
		if id in res[a]:
			res[a] = res[a][:-1]+","+word+'\n'
			break

	inp = open("user.txt","w")
	for i in res:
		inp.write(i)

#Dua ra 1 goi y
def someExam(word,subject):
	inp = open("words.csv","r")
	res = []
	for line in inp:
		if subject in line and word not in line:
			res.append(line.strip().split(','))

	i = random.randint(0,len(res)-1)
	return res[i]



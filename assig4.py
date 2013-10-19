import urllib2
import sys
import time

TARGET = 'http://crypto-class.appspot.com/po?er='
CYPH = 'f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4'

def hex(arr):
    return "".join(map(chr,arr)).encode('hex')

def arrXor(x,y):
    return [a^b for (a,b) in zip(x,y)]

#--------------------------------------------------------------
# padding oracle
#--------------------------------------------------------------
class PaddingOracle(object):
    def query(self, a):
        q = a[:]
        n = len(q)
        q.reverse()

        arr = map(ord, list(CYPH.decode('hex')))
        toXor = [0]*(len(arr)-n-16) + [n ^ a for a in q] + [0]*16
        g = hex(arrXor(arr,toXor))
        
        target = TARGET + urllib2.quote(g)    # Create query URL
        req = urllib2.Request(target)         # Send HTTP request to server
        try:
            f = urllib2.urlopen(req)          # Wait for response
            return True
        except urllib2.HTTPError, e:          
            if e.code == 404:
                print
                print g
                return True # good padding
            return False # bad padding

if __name__ == "__main__":
    po = PaddingOracle()
    guess = []
    output = ""

    while len(CYPH) > 0:
        while len(guess) >= 16:
            guess.reverse()
            output = ''.join(map(chr,guess[-16:])) + output
            guess.reverse()
            guess = guess[16:]
            CYPH = CYPH[:-32]

        for b in range(256):
            sys.stdout.write("%d." % b)
            sys.stdout.flush()
            guess.append(b)
            if po.query(guess):
                print "Found bit!"
                p = guess[:]
                p.reverse()
                print guess
                print ''.join(map(chr,p)) + output
                break
            else:
                guess.pop()

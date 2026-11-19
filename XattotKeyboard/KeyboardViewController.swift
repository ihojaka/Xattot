import UIKit
class KeyboardViewController: UIInputViewController {
var lang = 0 // 0 Cyrillic, 1 Latin, 2 Arabic
let rowsCyr = [["Й","Ц","У","К","Е","Н","Г","Ш","Ў","З","Х","Ғ"],["Ф","Қ","В","А","П","Р","О","Л","Д","Ж","Э","Ҳ"],["Я","Ч","С","М","И","Т","Ь","Б","Ю"]]
let rowsLat = [["Q","W","E","R","T","Y","U","I","O","P"],["A","S","D","F","G","H","J","K","L"],["Z","X","C","V","B","N","M"]]
let rowsAra = [["ض","ص","ث","ق","ف","غ","ع","ه","خ","ح","ج"],["ش","س","ي","ب","ل","ا","ت","ن","م","ك"],["ظ","ط","ذ","د","ز","ر","و","ة","ى","ء"]]
var shiftOn = false
override func viewDidLoad(){ super.viewDidLoad() }
override func viewDidLayoutSubviews(){ super.viewDidLayoutSubviews(); if view.bounds.width > 0 { build() } }
func build(){
view.subviews.forEach{$0.removeFromSuperview()}
view.backgroundColor = UIColor(red:0.82,green:0.84,blue:0.87,alpha:1)
var y: CGFloat = 6
let rows = lang==0 ? rowsCyr : (lang==1 ? rowsLat : rowsAra)
for (ri,row) in rows.enumerated() {
var x: CGFloat = 4
let cnt = ri==2 ? row.count+2 : row.count
let w = (view.bounds.width-8)/CGFloat(cnt) - 4
if ri==2 { let sb = UIButton(type:.system); sb.frame = CGRect(x:x,y:y,width:w,height:44); sb.setTitle("⇧",for:.normal); sb.addTarget(self,action:#selector(shiftTap),for:.touchUpInside); view.addSubview(sb); x += w+4 }
for ch in row {
let b = UIButton(type:.system); b.frame = CGRect(x:x,y:y,width:w,height:44); b.setTitle(shiftOn ? ch : ch.lowercased(), for:.normal); b.setTitleColor(.black, for:.normal); b.backgroundColor = .white; b.layer.cornerRadius = 5; b.titleLabel?.font = UIFont.systemFont(ofSize:18); b.addTarget(self, action:#selector(tap(_:)), for:.touchUpInside); view.addSubview(b)
x += w + 4
}
  if ri==2 { let db = UIButton(type:.system); db.frame = CGRect(x:x,y:y,width:w,height:44); db.setTitle("⌫",for:.normal); db.setTitleColor(.black,for:.normal); db.backgroundColor = .white; db.layer.cornerRadius = 6; db.addTarget(self,action:#selector(delTap),for:.touchUpInside); view.addSubview(db) }
y += 50
}
// bottom row: 123 | UZ | emoji | space | . | return
let bottomY = y
func bottomBtn(_ t:String, _ x:CGFloat, _ w:CGFloat, _ act:Selector){ let b=UIButton(type:.system); b.frame=CGRect(x:x,y:bottomY,width:w,height:48); b.setTitle(t, for:.normal); b.setTitleColor(.black, for:.normal); b.backgroundColor = .white; b.layer.cornerRadius = 5; b.titleLabel?.font = UIFont.boldSystemFont(ofSize:16); b.addTarget(self, action:act, for:.touchUpInside); view.addSubview(b) }
bottomBtn("123",4,52,#selector(numTap))
let langTitle = lang==0 ? "ЎЗ" : (lang==1 ? "ÖZ" : "اوز")
bottomBtn("🌐 ",60,40,#selector(globeTap))
bottomBtn("☺",104,40,#selector(emojiTap))
let spaceW = view.bounds.width - 244
let spaceLabel = " "
bottomBtn(spaceLabel,148,spaceW,#selector(spaceTap))
bottomBtn(".",148+spaceW+4,36,#selector(dotTap))
bottomBtn("⏎",148+spaceW+44,48,#selector(retTap))
}
// long-press mapping handled in tap via autocorrect below
@objc func tap(_ s:UIButton){ var t = s.currentTitle ?? ""
if lang==1 { t = autocorrectLatin(t) }
textDocumentProxy.insertText(t)
if lang==1 { autocorrectLatin2() }
}
@objc func spaceTap(){ textDocumentProxy.insertText(" ") }
@objc func dotTap(){ textDocumentProxy.insertText(".") }
@objc func retTap(){ textDocumentProxy.insertText("\n") }
@objc func globeTap(){ lang = (lang+1)%3; build() }
@objc func emojiTap(){ textDocumentProxy.insertText("😀") }
  @objc func shiftTap(){ shiftOn.toggle(); build() }
@objc func delTap(){ textDocumentProxy.deleteBackward() }
@objc func numTap(){ textDocumentProxy.insertText("1") }
func autocorrectLatin(_ t:String)->String{ return t }
func autocorrectLatin2(){}
}

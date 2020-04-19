import AppKit

extension NSTextView {

	var text: String! {
		get {
			return string
		}
		set {
			self.string = newValue
		}
	}

	var tintColor: Color {
		set {
			insertionPointColor = newValue
		}
		get {
			return insertionPointColor
		}
	}
}

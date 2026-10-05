import Cocoa
import FlutterMacOS
import PDFKit

public class FlutterHtmlToPdfPlusPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_html_to_pdf_plus", binaryMessenger: registrar.messenger)
        let instance = FlutterHtmlToPdfPlusPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "convertHtmlToPdf":
            guard let args = call.arguments as? [String: Any],
                let htmlFilePath = args["htmlFilePath"] as? String,
                let width = args["width"] as? Int,
                let height = args["height"] as? Int,
                let orientation = args["orientation"] as? String,
                let margins = args["margins"] as? [Int],
                let printSize = args["printSize"] as? String
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Missing or invalid arguments",
                        details: nil))
                return
            }

            // Handle the conversion on a background thread to avoid blocking the main thread
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Get HTML content from file
                    let htmlFileContent = FileHelper.getContent(from: htmlFilePath)

                    // Create PDF from HTML content
                    let convertedFileURL = PDFCreator.create(
                        htmlContent: htmlFileContent,
                        width: Double(width),
                        height: Double(height),
                        orientation: orientation,
                        margins: margins
                    )

                    // Return the path to the generated PDF on the main thread
                    DispatchQueue.main.async {
                        result(convertedFileURL.path)
                    }
                } catch {
                    // Return error on the main thread
                    DispatchQueue.main.async {
                        result(
                            FlutterError(
                                code: "PDF_GENERATION_ERROR",
                                message: error.localizedDescription,
                                details: nil))
                    }
                }
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

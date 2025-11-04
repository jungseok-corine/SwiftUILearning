////
////  ImportCoreML.swift
////  SwiftUILearning
////
////  Created by 오정석 on 28/10/2025.
////
//
//import CoreML
//import UIKit
//import Vision // CoreML 과 작업을 할 때 이미지를 보다 쉽게 처리할 수 있게 도와주는 프레임워크
//
//class ImportCoreML: UIViewController {
//    weak var imageView: UIImageView!
//
//    var imagePicker: UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera // 기본값은 카메라 라이브러리, 이미지를 찍을 수 있게 설정
//        picker.allowsEditing = true // 선택한 이미지나 동영상 편집 여부를 설정(Bool
//        return picker
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    func cameraTapped(_ sender: UIBarButtonItem) {
//        // UIImagePickerController 도 ViewController 이므로 present로 불러와야 한다.
//        present(imagePicker, animated: true)
//    }
//}
//
//// MARK: - CoreML 이미지 분류
//
//extension ImportCoreML {
//    // CoreML 의 CIImage를 처리하고 해석하기 위한 메서드 생성, 이것은 모델의 이미지를 분류하기 위해 사용 됩니다.
//    func detectImage(image: CIImage) {
//        // CoreML의 모델인 FlowerClassifier를 객체를 생성 후,
//        // Vision 프레임워크인 VNCoreMLModel 컨테이너를 사용하여 CoreML의 model에 접근한다.
//        guard let coreMLModel = try? MobileNetV2(configuration: MLModelConfiguration()),
//              let visionModel = try? VNCoreMLModel(for: coreMLModel.model)
//        else {
//            fatalError("Loading CoreML Model Failed")
//        }
//
//        // Vision 을 이용해 이미지 처리를 요청
//        let request = VNCoreMLRequest(model: visionModel) { request, error in
//            guard error == nil else {
//                fatalError("Failed Request")
//            }
//
//            // 식별자의 이름(꽃 이름)을 확인하기 위해 VNClassificationObservation 로 변환해준다.
//            guard let classification = request.results as? [VNClassificationObservation] else {
//                fatalError("Failed convert VNClassificationObservation")
//            }
//
//            // 타이틀을 가장 정확도 높은 이름으로 설정
//            if let firstItem = classification.first {
//                self.navigationItem.title = firstItem.identifier.capitalized
//            }
//
//            // 머신러닝을 통한 결과값 프린트
//            print("#### \(classification)")
//        }
//
//        // 이미지를 받아와서 perform을 요청하여 분석한다. (Vision 프레임워크)
//        let handler = VNImageRequestHandler(ciImage: image)
//
//        do {
//            try handler.perform([request])
//        } catch {
//            print(error)
//        }
//    }
//}
//
//// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
//
//extension ImportCoreML: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    // 사진을 찍은 후 이미지를 갖고 할 일들을 정의
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        picker.dismiss(animated: true)
//
//        // info의 키 값으로 수정한 사진 이미지 받아온다.
//        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            fatalError("Failed Original Image pick")
//        }
//
//        // 위에서 받은 이미지를 이미지 뷰에 저장
//        imageView.image = userPickedImage
//
//        // Core모델 이미지로 사용하기 위해 CIImage로 변환
//        guard let coreImage = CIImage(image: userPickedImage) else {
//            fatalError("Faild convert CIImage")
//        }
//
//        // 변환 된 CIImage를 갖고 이미지를 처리하는 메서드 호출
//        detectImage(image: coreImage)
//    }
//}
